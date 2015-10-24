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
  end  
end