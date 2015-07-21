require 'rails_helper'

describe "Allocations" do
  describe "POST /allocations" do
    let(:allocation_params) { {
      allocation: {
        group_id: group.id,
        user_id: user.id,
        amount: "25"
      }
    }.to_json }

    context 'admin' do
      before { make_user_group_admin }

      it "creates an allocation" do
        post "/allocations", allocation_params, request_headers
        expect(response.status).to eq created
        expect(Allocation.find_by(group: group, user: user, amount: 25)).to be_truthy
      end
    end

    context 'user' do
      before { make_user_group_member }

      it "cannot create allocations" do
        post "/allocations", allocation_params, request_headers
        expect(response.status).to eq forbidden
        expect(Allocation.find_by(group: group, user: user, amount: 25)).to be_nil
      end
    end
  end

  describe "PUT /allocations/:allocation_id" do
    let(:evil_group) { create(:group) }
    let(:allocation_params) { {
      allocation: {
        amount: "15",
        group_id: evil_group.id 
      }
    }.to_json }
    let(:allocation) { create(:allocation, amount: 2, group: group) }

    context 'admin' do
      before do
        make_user_group_admin
        put "/allocations/#{allocation.id}", allocation_params, request_headers
        allocation.reload
      end

      it "updates an allocation" do
        expect(response.status).to eq updated
        expect(allocation.amount).to eq 15
      end

      it "cannot update group_id" do
        expect(response.status).to eq updated
        expect(allocation.group_id).not_to eq evil_group.id
      end
    end

    context 'user' do
      before { make_user_group_member }

      it "cannot update an allocation" do
        put "/allocations/#{allocation.id}", allocation_params, request_headers
        allocation.reload
        expect(response.status).to eq forbidden
        expect(allocation.amount).not_to eq 15
      end
    end
  end
end
