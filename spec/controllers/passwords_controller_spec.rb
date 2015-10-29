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
end
