require 'rails_helper'

RSpec.describe Overrides::PasswordsController, :type => :controller do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#create" do
    context "email exists" do
      before do
        post :create, {email: user.email}
      end
      it "returns http status ok" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "email does not exist" do
      before do
        post :create, {email: "coffee@coffee.coffee"}
      end
      it "returns http status 400" do
        expect(response).to have_http_status(400)
      end
    end
  end
end