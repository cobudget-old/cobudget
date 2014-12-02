require 'rails_helper'

describe "Auth" do
  let(:user) { FactoryGirl.create(:user) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
  } }

  describe "POST /auth/log_in" do
    it "returns an auth token if valid email and password given" do
      user_params = {
        user: {
          email: user.email,
          password: user.password,
        }
      }.to_json

      post "/auth/log_in", user_params, request_headers

      body = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(body['user']['access_token']).to eq user.access_token
    end

    it "returns error if invalid email and password given" do
      user_params = {
        user: {
          email: user.email,
          password: 'bad password',
        }
      }.to_json

      post "/auth/log_in", user_params, request_headers

      body = JSON.parse(response.body)
      expect(body['user']).to eq nil
      expect(response.status).to eq 401
    end
  end
end
