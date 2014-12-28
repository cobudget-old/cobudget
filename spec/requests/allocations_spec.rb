require 'rails_helper'

describe "Allocations" do
  describe "POST /allocations" do
    let(:allocation_params) { {
      allocation: {
        round_id: round.id,
        user_id: user.id,
        amount_cents: 2500
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }

      it "creates an allocation" do
        post "/allocations", allocation_params, request_headers
        alloc = Allocation.first
        expect(response.status).to eq created
        expect(alloc.amount_cents).to eq 2500
        expect(alloc.user).to eq user
      end
    end

    context 'user' do
      before { make_user_group_member }

      it "cannot create allocations" do
        post "/allocations", allocation_params, request_headers
        alloc = Allocation.first
        expect(response.status).to eq forbidden
        expect(alloc).to eq nil
      end
    end
  end

  describe "PUT /allocations/:allocation_id" do
    let(:evil_round) { FactoryGirl.create(:round) }
    let(:allocation_params) { {
      allocation: {
        amount_cents: 1500,
        round_id: evil_round.id
      }
    }.to_json }
    let(:allocation) { FactoryGirl.create(:allocation, amount_cents: 200, round: round) }

    context 'admin' do
      before { make_user_group_admin }

      it "updates an allocation" do
        put "/allocations/#{allocation.id}", allocation_params, request_headers
        allocation.reload
        expect(response.status).to eq updated
        expect(allocation.amount_cents).to eq 1500
        expect(allocation.round_id).not_to eq evil_round.id
      end
    end

    context 'user' do
      before { make_user_group_member }

      it "cannot update an allocation" do
        put "/allocations/#{allocation.id}", allocation_params, request_headers
        allocation.reload
        expect(response.status).to eq forbidden
        expect(allocation.amount_cents).not_to eq 1500
      end
    end
  end
end
