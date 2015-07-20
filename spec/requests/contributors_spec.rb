require 'rails_helper'

describe "Memberships" do
  describe "GET /rounds/:round_id/contributors/" do
    it "displays contributors information for given round" do
      membership = create(:membership, group: group)
      allocation = create(:allocation, round: round, amount: 2.5) # 2.5 dollas
      allocation2 = create(:allocation, round: round, amount: 5) # 5 dollas
      bucket = create(:bucket, round: round)
      bucket2 = create(:bucket, round: round) 
      contribution = create(:contribution, bucket: bucket, user: allocation2.user, amount: 1) # allocation 1 now 1.5 dollas 
      contribution2 = create(:contribution, bucket: bucket2, user: allocation2.user, amount: 2) # allocation 2 now 3 dollas

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
      expect(body["contributors"][2]["user"]["id"]).to eq membership.member_id
    end
  end
end