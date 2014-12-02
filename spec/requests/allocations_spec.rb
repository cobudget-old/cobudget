require 'rails_helper'

describe "Allocations" do
  let(:admin) { FactoryGirl.create(:user) }
  let(:user) { FactoryGirl.create(:user) }
  let(:round) { FactoryGirl.create(:round) }
  let(:allocation) { FactoryGirl.create(:allocation) }

  let(:request_headers) { {
    "Accept" => "application/json",
    "Content-Type" => "application/json",
    "X-User-Token" => admin.access_token,
    "X-User-Email" => admin.email,
  } }

  describe "POST /allocations" do
    it "creates an allocation" do
      allocation_params = {
        allocation: {
          round_id: round.id,
          user_id: user.id,
          amount_cents: 2500
        }
      }.to_json

      post "/allocations", allocation_params, request_headers

      alloc = Allocation.first

      expect(response.status).to eq 201 # created
      expect(alloc.amount_cents).to eq 2500
      expect(alloc.user).to eq user
    end
  end

  describe "PUT /allocations/:allocation_id" do
    it "updates an allocation" do
      allocation_params = {
        allocation: {
          amount_cents: 1500
        }
      }.to_json
      expect(allocation.amount_cents).not_to eq 1500

      put "/allocations/#{allocation.id}", allocation_params, request_headers

      allocation.reload
      expect(response.status).to eq 204 # updated
      expect(allocation.amount_cents).to eq 1500
    end
  end
end
