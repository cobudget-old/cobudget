require 'rails_helper'

describe "Rounds" do
  let(:user) { FactoryGirl.create(:user) }
  let(:group) { FactoryGirl.create(:group) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => user.authentication_token,
    "X-User-Email" => user.email,
  } }

  describe "POST /rounds" do
    it "creates a round" do
      round_params = {
        round: {
          name: "November Surplus",
          group_id: group.id
        }
      }.to_json

      post "/rounds", round_params, request_headers

      expect(response.status).to eq 201 # created
      expect(Round.first.name).to eq "November Surplus"
    end
  end
end
