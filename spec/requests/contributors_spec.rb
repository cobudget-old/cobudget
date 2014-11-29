require 'rails_helper'

describe "Memberships" do
  let(:user) { FactoryGirl.create(:user) }
  let(:round) { FactoryGirl.create(:round) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => user.authentication_token,
    "X-User-Email" => user.email,
  } }

  describe "GET /rounds/:round_id/contributors/" do
    it "displays contributors information for given round" do
      membership = FactoryGirl.create(:membership, group: round.group)
      allocation = FactoryGirl.create(:allocation, round: round, amount_cents: 250)
      allocation2 = FactoryGirl.create(:allocation, round: round, amount_cents: 500)
      bucket = FactoryGirl.create(:bucket, round: round)
      bucket2 = FactoryGirl.create(:bucket, round: round)
      contribution = FactoryGirl.create(:contribution, bucket: bucket, user: allocation2.user, amount_cents: 100)
      contribution2 = FactoryGirl.create(:contribution, bucket: bucket2, user: allocation2.user, amount_cents: 200)

      get "/rounds/#{round.id}/contributors/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)

      #
      # Contributors ordered by highest allocation first
      #

      expect(body["contributors"][0]["allocation"]["amount_cents"]).to eq 500
      expect(body["contributors"][0]["user"]["id"]).to eq allocation2.user_id

      # Contributor's contributions ordered highest to lowest
      expect(body["contributors"][0]["contributions"][0]["amount_cents"]).to eq contribution2.amount_cents
      expect(body["contributors"][0]["contributions"][1]["amount_cents"]).to eq contribution.amount_cents

      expect(body["contributors"][1]["allocation"]["amount_cents"]).to eq 250
      expect(body["contributors"][1]["user"]["id"]).to eq allocation.user_id

      # Contributors without allocations come last
      expect(body["contributors"][2]["allocation"]).to eq nil
      expect(body["contributors"][2]["user"]["id"]).to eq membership.user_id
    end
  end
end
