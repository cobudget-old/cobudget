require 'rails_helper'

describe UsersController, :type => :controller do
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