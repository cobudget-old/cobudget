require 'rails_helper'

describe "FixedCosts" do
  let(:user) { FactoryGirl.create(:user) }
  let(:round) { FactoryGirl.create(:round) }
  let(:membership) { FactoryGirl.create(:membership, group: round.group, user: user) }
  let(:admin_membership) { FactoryGirl.create(:membership,
                           group: round.group, user: user, is_admin: true) }

  describe "POST /fixed_costs" do
    let(:fixed_cost_params) { {
      fixed_cost: {
        round_id: round.id,
        name: "Rent",
        amount_cents: 80000,
        description: "Too much!"
      }
    }.to_json }

    context 'admin' do
      before { admin_membership }

      it "creates a fixed_cost" do
        post "/fixed_costs", fixed_cost_params, request_headers

        fixed_cost = FixedCost.first
        expect(response.status).to eq 201 # created
        expect(fixed_cost.name).to eq "Rent"
        expect(fixed_cost.amount_cents).to eq 80000
        expect(fixed_cost.description).to eq "Too much!"
      end
    end

    context 'member' do
      before { membership }

      it "cannot create a fixed_cost" do
        post "/fixed_costs", fixed_cost_params, request_headers

        fixed_cost = FixedCost.first
        expect(response.status).to eq 403
        expect(fixed_cost).to eq nil
      end
    end
  end

  describe "PUT /fixed_costs/:fixed_cost_id" do
    let(:evil_round) { FactoryGirl.create(:group) }
    let(:fixed_cost_params) { {
      fixed_cost: {
        amount_cents: 1500,
        round_id: evil_round.id
      }
    }.to_json }
    let(:fixed_cost) { FactoryGirl.create(:fixed_cost, round: round,
                                          amount_cents: 300) }

    context 'admin' do
      before { admin_membership }
      it "updates a fixed_cost" do
        put "/fixed_costs/#{fixed_cost.id}", fixed_cost_params, request_headers
        fixed_cost.reload
        expect(response.status).to eq updated
        expect(fixed_cost.amount_cents).to eq 1500
        expect(fixed_cost.round_id).not_to eq evil_round.id
      end
    end

    context 'member' do
      before { membership }
      it "updates a fixed_cost" do
        put "/fixed_costs/#{fixed_cost.id}", fixed_cost_params, request_headers
        fixed_cost.reload
        expect(response.status).to eq forbidden
        expect(fixed_cost.amount_cents).to eq 300
      end
    end
  end

  describe "DELETE /fixed_costs/:fixed_cost_id" do
    let(:fixed_cost) { FactoryGirl.create(:fixed_cost, round: round,
                                          amount_cents: 300) }
    context 'admin' do
      before { admin_membership }
      it "deletes a fixed_cost" do
        delete "/fixed_costs/#{fixed_cost.id}", {}, request_headers
        expect { fixed_cost.reload }.to raise_error
      end
    end

    context 'member' do
      before { membership }
      it "cannot delete fixed cost" do
        delete "/fixed_costs/#{fixed_cost.id}", {}, request_headers
        fixed_cost.reload
        expect(response.status).to eq forbidden
        expect(fixed_cost.amount_cents).to eq 300
      end
    end
  end

  describe "GET /rounds/:round_id/fixed_costs/" do
    it "displays fixed costs for a round" do
      fixed_cost1 = FactoryGirl.create(:fixed_cost, amount_cents: 5432, round_id: round.id)
      fixed_cost2 = FactoryGirl.create(:fixed_cost, amount_cents: 5432, round_id: round.id)

      get "/rounds/#{round.id}/fixed_costs/", {}, request_headers

      expect(response.status).to eq success

      body = JSON.parse(response.body)
      expect(body["fixed_costs"][0]["amount_cents"]).to eq 5432
      expect(body["fixed_costs"][1]["amount_cents"]).to eq 5432
    end
  end
end
