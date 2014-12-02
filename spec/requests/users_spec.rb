require 'rails_helper'

describe "Users" do
  let(:round) { FactoryGirl.create(:round) }
  let(:user) { FactoryGirl.create(:user) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => user.access_token,
    "X-User-Email" => user.email,
  } }

  describe "GET /users/" do
    it "displays users" do
      user2 = FactoryGirl.create(:user)

      get "/users/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)
      names = []
      names << body["users"][0]["name"]
      names << body["users"][1]["name"]
      expect(names).to include(user.name)
      expect(names).to include(user2.name)
    end
  end
end
