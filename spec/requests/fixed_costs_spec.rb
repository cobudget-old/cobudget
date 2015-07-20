require 'rails_helper'

describe "FixedCosts" do
  let(:user) { create(:user) }
  let(:round) { create(:round) }
  let(:membership) { create(:membership, group: round.group, member: user) }
  let(:admin_membership) { create(:membership,
                           group: round.group, member: user, is_admin: true) }

  describe "POST /fixed_costs" do
    let(:fixed_cost_params) { {
      fixed_cost: {
        round_id: round.id,
        name: "Rent",
        amount: "800",
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
        expect(fixed_cost.amount).to eq 800
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
    let(:evil_round) { create(:group) }
    let(:fixed_cost_params) { {
      fixed_cost: {
        amount: 15,
        round_id: evil_round.id
      }
    }.to_json }
    let(:fixed_cost) { create(:fixed_cost, round: round,
                                          amount: 3) }

    context 'admin' do
      before { admin_membership }
      it "updates a fixed_cost" do
        put "/fixed_costs/#{fixed_cost.id}", fixed_cost_params, request_headers
        fixed_cost.reload
        expect(response.status).to eq updated
        expect(fixed_cost.amount).to eq 15
        expect(fixed_cost.round_id).not_to eq evil_round.id
      end
    end

    context 'member' do
      before { membership }
      it "updates a fixed_cost" do
        put "/fixed_costs/#{fixed_cost.id}", fixed_cost_params, request_headers
        fixed_cost.reload
        expect(response.status).to eq forbidden
        expect(fixed_cost.amount).to eq 3
      end
    end
  end

  describe "DELETE /fixed_costs/:fixed_cost_id" do
    let(:fixed_cost) { create(:fixed_cost, round: round,
                                          amount: 3) }
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
        expect(fixed_cost.amount).to eq 3
      end
    end
  end

  describe "GET /rounds/:round_id/fixed_costs/" do
    it "displays fixed costs for a round" do
      fixed_cost1 = create(:fixed_cost, amount: 54.32, round_id: round.id)
      fixed_cost2 = create(:fixed_cost, amount: 54.32, round_id: round.id)

      get "/rounds/#{round.id}/fixed_costs/", {}, request_headers

      expect(response.status).to eq success

      body = JSON.parse(response.body)
      expect(body["fixed_costs"][0]["amount"]).to eq "54.32"
      expect(body["fixed_costs"][1]["amount"]).to eq "54.32"
    end
  end
end
