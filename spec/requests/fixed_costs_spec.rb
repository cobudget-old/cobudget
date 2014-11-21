require 'rails_helper'

describe "FixedCosts" do
  let(:admin) { FactoryGirl.create(:user) }
  let(:round) { FactoryGirl.create(:round) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => admin.authentication_token,
    "X-User-Email" => admin.email,
  } }

  describe "POST /fixed_costs" do
    it "creates a fixed_cost" do
      fixed_cost_params = {
        fixed_cost: {
          round_id: round.id,
          name: "Rent",
          amount_cents: 80000
        }
      }.to_json

      post "/fixed_costs", fixed_cost_params, request_headers

      fixed_cost = FixedCost.first
      expect(response.status).to eq 201 # created
      expect(fixed_cost.name).to eq "Rent"
      expect(fixed_cost.amount_cents).to eq 80000
    end
  end
end
