require 'rails_helper'

RSpec.describe Overrides::PasswordsController, :type => :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  after do
    ActionMailer::Base.deliveries.clear    
  end

  describe "#create" do
    context "user has already set up their account" do
      it "returns http status ok" do
        post :create, {email: user.email}
        expect(response).to have_http_status(:ok)
      end

      it "creates a reset_password_token for the user" do
        post :create, {email: user.email}
        user.reload
        expect(user.reset_password_token).to be_truthy
      end
      
      it "sends them a reset password email with link to reset_password page containing their reset_password_token" do
        post :create, {email: user.email}
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
        post :create, {email: user.email}
        expect(response).to have_http_status(:ok)
      end

      it "sends them a reset password email with link to confirm_account page containing their confirmation_token" do
        post :create, {email: user.email}
        @sent_email = ActionMailer::Base.deliveries.first
        expect(@sent_email.to).to eq([user.email])
        expected_url = "/#/confirm_account?confirmation_token=#{user.confirmation_token}"
        expect(@sent_email.body.to_s).to include(expected_url)
        ActionMailer::Base.deliveries.clear
      end
    end

    context "user email does not exist" do
      before do
        post :create, {email: "coffee@coffee.coffee"}
      end

      it "returns http status 400" do
        expect(response).to have_http_status(400)
      end
    end
  end

  describe "#update" do
    context "reset_password_token present in request" do
      context "reset_password_token matches user" do
        before do
          require 'securerandom'
          reset_password_token = SecureRandom.urlsafe_base64.to_s
          user.update(reset_password_token: reset_password_token)
          @old_encrypted_password = user.encrypted_password
          patch :update, {reset_password_token: reset_password_token, password: "password", confirm_password: "password"}
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
      end

      context "passwords don't match" do
        before do
          reset_password_token = SecureRandom.urlsafe_base64.to_s
          user.update(reset_password_token: reset_password_token)
          patch :update, {reset_password_token: reset_password_token, password: "password", confirm_password: "potato"}
        end

        it "returns http status unprocessable" do
          expect(response).to have_http_status(422)
        end
      end

      context "reset_password_token does not match user" do
        it "returns http status forbidden" do
          patch :update, {reset_password_token: "meow", password: "password", confirm_password: "password"}
          expect(response).to have_http_status(:forbidden)
        end
      end
    end

    context "reset_password_token not present in request" do
      it "returns http status unprocessable" do
        patch :update
        expect(response).to have_http_status(422)
      end
    end
  end
end
