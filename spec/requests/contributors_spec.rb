require 'rails_helper'

describe "Memberships" do
  describe "GET /rounds/:round_id/contributors/" do
    it "displays contributors information for given round" do
      membership = FactoryGirl.create(:membership, group: group)
      allocation = FactoryGirl.create(:allocation, round: round, amount: 2.5)
      allocation2 = FactoryGirl.create(:allocation, round: round, amount: 5)
      bucket = FactoryGirl.create(:bucket, round: round)
      bucket2 = FactoryGirl.create(:bucket, round: round)
      contribution = FactoryGirl.create(:contribution, bucket: bucket, user: allocation2.user, amount: 1)
      contribution2 = FactoryGirl.create(:contribution, bucket: bucket2, user: allocation2.user, amount: 2)

      get "/rounds/#{round.id}/contributors/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)

      #
      # Contributors ordered by highest allocation first
      #

      expect(body["contributors"][0]["allocation"]["amount"]).to eq "5.0"
      expect(body["contributors"][0]["user"]["id"]).to eq allocation2.user_id

      # Contributor's contributions ordered highest to lowest
      expect(body["contributors"][0]["contributions"][0]["amount"]).to eq contribution2.amount.to_s
      expect(body["contributors"][0]["contributions"][1]["amount"]).to eq contribution.amount.to_s

      expect(body["contributors"][1]["allocation"]["amount"]).to eq "2.5"
      expect(body["contributors"][1]["user"]["id"]).to eq allocation.user_id

      # Contributors without allocations come last
      expect(body["contributors"][2]["allocation"]).to eq nil
      expect(body["contributors"][2]["user"]["id"]).to eq membership.user_id
    end
  end
end
