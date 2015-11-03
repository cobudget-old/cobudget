require 'rails_helper'

describe UsersController, :type => :controller do
  describe "#confirm_account" do
    context "active confirmation token" do
      before do
        @user = User.create_with_confirmation_token(email: Faker::Internet.email)
        request_params = {
          name: "new name",
          password: "password",
          confirmation_token: @user.confirmation_token
        }
        post :confirm_account, request_params
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
  end

  describe "#create" do
    before do
      make_user_group_admin
      request.headers.merge!(user.create_new_auth_token)
    end

    context "params[:invite_group] specified" do
      before do
        user_params = {email: Faker::Internet.email}
        post :create, {invite_group: true, user: user_params}
        @new_user = User.find_by(user_params)
        @sent_email = ActionMailer::Base.deliveries.first
      end

      after do
        ActionMailer::Base.deliveries.clear
      end

      it "creates a new user with confirmation token" do
        expect(@new_user).to be_truthy
        expect(@new_user.confirmation_token).to be_truthy
      end

      it "sends email to user with link to confirm account page containing confirmation_token and create_group flag " do
        expect(@sent_email.to).to eq([@new_user.email])
        expected_url = "/#/confirm_account?confirmation_token=#{@new_user.confirmation_token}&create_group=true"
        expect(@sent_email.body.to_s).to include(expected_url)
      end
    end

    context "user email not unique" do
      before do
        make_user_group_admin
        request.headers.merge!(user.create_new_auth_token)
        create(:user, email: "meow@meow.com")
        @user_params = {email: "meow@meow.com"}
        post :create, {user: @user_params}
      end

      it "does not create user" do
        expect(User.where(@user_params).length).to eq(1)
      end

      it "returns http status conflict" do
        expect(response).to have_http_status(:conflict)
      end
    end
  end

  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  after do
    ActionMailer::Base.deliveries.clear    
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

        it "returns http status updated" do
          expect(response).to have_http_status(204)
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
end