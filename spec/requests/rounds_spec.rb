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
      time_now = Time.new(2007,11,1,15,25,0, "+09:00")

      round_params = {
        round: {
          group_id: group.id,
          name: "November Surplus",
          starts_at: time_now,
          ends_at: time_now + 3.days
        }
      }.to_json

      post "/rounds", round_params, request_headers
      round = Round.first

      expect(response.status).to eq 201 # created

      expect(round.name).to eq "November Surplus"
      expect(round.starts_at).to eq time_now
      expect(round.ends_at).to eq time_now + 3.days
    end
  end
end
