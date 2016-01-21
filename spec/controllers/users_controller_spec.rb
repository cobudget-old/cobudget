require 'rails_helper'

describe UsersController, :type => :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#confirm_account" do
    context "active confirmation token" do
      before do
        @user = User.create_with_confirmation_token(email: Faker::Internet.email)
        @request_params = {
          name: "new name",
          password: "password",
          confirmation_token: @user.confirmation_token
        }
      end

      context "name and password specified" do
        before do
          post :confirm_account, @request_params
          @parsed_response = JSON.parse(response.body)
          @user.reload
        end

        it "updates user with specified name, and password, and clears confirmation token" do
          expect(@user.name).to eq("new name")
          expect(@user.confirmation_token).to be_nil
        end

        it "returns user as json" do
          expect(@parsed_response["users"][0]["id"]).to eq(@user.id)
        end
      end

      context "password not specified" do
        before do
          @request_params[:password] = nil
          post :confirm_account, @request_params
          @user.reload
        end

        it "returns http status bad_request" do
          expect(response).to have_http_status(:bad_request)
        end

        it "does not update user" do
          expect(@user.name).not_to eq("new name")
          expect(@user.confirmation_token).not_to be_nil
        end
      end

      context "name not specified" do
        before do
          @request_params[:name] = nil
          post :confirm_account, @request_params
        end

        it "returns http status bad_request" do
          expect(response).to have_http_status(:bad_request)
        end

        it "does not update user" do
          expect(@user.name).not_to eq("password")
          expect(@user.confirmation_token).not_to be_nil
        end
      end
    end

    context "stale confirmation token" do
      before do
        @user = User.create_with_confirmation_token(email: Faker::Internet.email)
        confirmation_token = @user.confirmation_token
        @user.update(confirmation_token: nil)
        request_params = {
          name: "new name",
          password: "password",
          confirmation_token: confirmation_token
        }
        post :confirm_account, request_params
      end

      it "returns http status forbidden" do
        expect(response).to have_http_status(:forbidden)
      end

      it "does not update user" do
        expect(@user.name).not_to eq("new name")
      end
    end

    context "no confirmation token" do
      before do
        request_params = {
          name: "new name",
          password: "password",
          confirmation_token: nil
        }
        post :confirm_account, request_params
      end

      it "returns http status bad_request" do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end

  describe "#invite_to_create_group" do
    before do
      make_user_group_admin
      request.headers.merge!(user.create_new_auth_token)
    end

    context "specified email does not yet exist in DB" do
      before do
        params = { email: Faker::Internet.email }
        post :invite_to_create_group, params
        @new_user = User.find_by(params)
        @sent_email = ActionMailer::Base.deliveries.first
        @new_group = @new_user.groups.first
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates a new user with confirmation token" do
        expect(@new_user).to be_truthy
        expect(@new_user.confirmation_token).to be_truthy
      end

      it "creates a temporary group for the user, and adds them as an admin to it" do
        expect(@new_group.name).to eq("New Group")
        expect(@new_user.is_admin_for?(@new_group)).to be_truthy
      end

      it "sends email to user with link to confirm account page containing confirmation_token and new group_id" do
        expect(@sent_email.to).to eq([@new_user.email])
        expected_url = "/#/confirm_account?confirmation_token=#{@new_user.confirmation_token}&group_id=#{@new_group.id}"
        expect(@sent_email.body.to_s).to include(expected_url)
      end
    end

    context "specified email already exists in DB" do
      before do
        make_user_group_admin
        request.headers.merge!(user.create_new_auth_token)
        create(:user, email: "meow@meow.com")
        @params = {email: "meow@meow.com"}
        post :invite_to_create_group, @params
      end

      it "does not create user" do
        expect(User.where(@params).length).to eq(1)
      end

      it "returns http status conflict" do
        expect(response).to have_http_status(:conflict)
      end
    end
  end

  describe "#update_profile" do
    context "user signed in" do
      before do
        make_user_group_member
        request.headers.merge!(user.create_new_auth_token)
        user_params = {
          utc_offset: -480
        }
        post :update_profile, {user: user_params}
        user.reload
      end

      it "updates the user with specified params" do
        expect(user.utc_offset).to eq(-480)
      end

      it "returns http status ok" do
        expect(response).to have_http_status(:ok)
      end

      it "returns the updated user as json" do
        parsed_response = JSON.parse(response.body)
        expect(parsed_response["users"][0]["id"]).to eq(user.id)
      end
    end

    context "user not signed in" do
      before do
        post :update_profile
      end

      it "returns http status unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#request_password_reset" do
    context "user has already set up their account" do
      it "returns http status ok" do
        post :request_password_reset, {email: user.email}
        expect(response).to have_http_status(:ok)
      end

      it "creates a reset_password_token for the user" do
        post :request_password_reset, {email: user.email}
        user.reload
        expect(user.reset_password_token).to be_truthy
      end

      it "sends them a reset password email with link to reset_password page containing their reset_password_token" do
        post :request_password_reset, {email: user.email}
        @sent_email = ActionMailer::Base.deliveries.first
        expect(@sent_email.to).to eq([user.email])
        expect(@sent_email.subject).to eq("Reset Password Instructions")
        expected_url = "/#/reset_password?reset_password_token=#{user.reset_password_token}"
        expect(@sent_email.body.to_s).to include(expected_url)
      end
    end

    context "user has not set up their account yet" do
      before do
        require 'securerandom'
        confirmation_token = SecureRandom.urlsafe_base64.to_s
        user.update(confirmation_token: confirmation_token)
      end

      it "returns http status ok" do
        post :request_password_reset, {email: user.email}
        expect(response).to have_http_status(:ok)
      end

      it "sends them a reset password email with link to confirm_account page containing their confirmation_token" do
        post :request_password_reset, {email: user.email}
        @sent_email = ActionMailer::Base.deliveries.first
        expect(@sent_email.to).to eq([user.email])
        expect(@sent_email.subject).to eq("Set up your Cobudget Account")
        expected_url = "/#/confirm_account?confirmation_token=#{user.confirmation_token}"
        expect(@sent_email.body.to_s).to include(expected_url)
        ActionMailer::Base.deliveries.clear
      end
    end

    context "user email does not exist" do
      before do
        post :request_password_reset, {email: "coffee@coffee.coffee"}
      end

      it "returns http status 400" do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "#reset_password" do
    context "reset_password_token present in request" do
      context "reset_password_token matches user" do
        before do
          require 'securerandom'
          reset_password_token = SecureRandom.urlsafe_base64.to_s
          user.update(reset_password_token: reset_password_token)
          @old_encrypted_password = user.encrypted_password
          post :reset_password, {reset_password_token: reset_password_token, password: "password", confirm_password: "password"}
          user.reload
        end

        it "returns http status ok" do
          expect(response).to have_http_status(:ok)
        end

        it "updates user's password" do
          expect(user.encrypted_password).not_to eq(@old_encrypted_password)
        end

        it "removes reset_password_token from user" do
          expect(user.reset_password_token).to be_nil
        end

        it "returns updated user as json" do
          parsed_response = JSON.parse(response.body)
          expect(parsed_response["users"][0]["id"]).to eq(user.id)
        end
      end

      context "passwords don't match" do
        before do
          reset_password_token = SecureRandom.urlsafe_base64.to_s
          user.update(reset_password_token: reset_password_token)
          post :reset_password, {reset_password_token: reset_password_token, password: "password", confirm_password: "potato"}
        end

        it "returns http status unprocessable" do
          expect(response).to have_http_status(422)
        end
      end

      context "reset_password_token does not match user" do
        it "returns http status forbidden" do
          post :reset_password, {reset_password_token: "meow", password: "password", confirm_password: "password"}
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "reset_password_token not present in request" do
      it "returns http status unprocessable" do
        post :reset_password
        expect(response).to have_http_status(422)
      end
    end
  end

  describe "#update_password" do
    let!(:user) { create(:user, password: "password") }

    context "user logged in" do
      before { request.headers.merge!(user.create_new_auth_token) }

      context "correct current_password specified" do
        let!(:params) { {current_password: "password"} }
        let!(:old_encrypted_password) { user.encrypted_password }

        context "password and confirm_password match" do
          before do
            params.merge!({password: "420blazeit", confirm_password: "420blazeit"})
            post :update_password, params
            user.reload
          end

          it "returns http status ok" do
            expect(response).to have_http_status(:ok)
          end

          it "updates the users password" do
            expect(user.encrypted_password).not_to eq(old_encrypted_password)
          end
        end

        context "password and confirm_password don't match" do
          before do
            params.merge!({password: "420blazeit", confirm_password: "421blazeit"})
            post :update_password, params
          end

          it "returns http status bad_request" do
            expect(response).to have_http_status(:bad_request)
          end
        end
      end

      context "current_password not specified" do
        before do
          post :update_password, {current_password: "", password: "420blazeit", confirm_password: "420blazeit"}
        end

        it "returns http status unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end
      end

      context "current_password incorrect" do
        before do
          post :update_password, {current_password: "wrongpassword", password: "420blazeit", confirm_password: "420blazeit"}
        end

        it "returns http status unauthorized" do
          expect(response).to have_http_status(:unauthorized)
        end
      end
    end

    context "user not logged in" do
      before do
        post :update_password, {current_password: "password", password: "420blazeit", confirm_password: "420blazeit"}
      end

      it "returns http status unauthorized" do
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
