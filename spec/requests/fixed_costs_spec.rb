require 'rails_helper'

describe "FixedCosts" do
  let(:admin) { FactoryGirl.create(:user) }
  let(:round) { FactoryGirl.create(:round) }
  let(:fixed_cost) { FactoryGirl.create(:fixed_cost) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => admin.access_token,
    "X-User-Email" => admin.email,
  } }

  describe "POST /fixed_costs" do
    it "creates a fixed_cost" do
      fixed_cost_params = {
        fixed_cost: {
          round_id: round.id,
          name: "Rent",
          amount_cents: 80000,
          description: "Too much!"
        }
      }.to_json

      post "/fixed_costs", fixed_cost_params, request_headers

      fixed_cost = FixedCost.first
      expect(response.status).to eq 201 # created
      expect(fixed_cost.name).to eq "Rent"
      expect(fixed_cost.amount_cents).to eq 80000
      expect(fixed_cost.description).to eq "Too much!"
    end
  end

  describe "PUT /fixed_costs/:fixed_cost_id" do
    it "updates an fixed_cost" do
      fixed_cost_params = {
        fixed_cost: {
          amount_cents: 1500
        }
      }.to_json
      expect(fixed_cost.amount_cents).not_to eq 1500

      put "/fixed_costs/#{fixed_cost.id}", fixed_cost_params, request_headers

      fixed_cost.reload
      expect(response.status).to eq 204 # updated
      expect(fixed_cost.amount_cents).to eq 1500
    end
  end

  describe "GET /rounds/:round_id/fixed_costs/" do
    it "displays fixed costs for a round" do
      fixed_cost1 = FactoryGirl.create(:fixed_cost, amount_cents: 5432, round_id: round.id)
      fixed_cost2 = FactoryGirl.create(:fixed_cost, amount_cents: 5432, round_id: round.id)

      get "/rounds/#{round.id}/fixed_costs/", {}, request_headers

      expect(response.status).to eq 200 # success

      body = JSON.parse(response.body)
      expect(body["fixed_costs"][0]["amount_cents"]).to eq 5432
      expect(body["fixed_costs"][1]["amount_cents"]).to eq 5432
    end
  end
end
