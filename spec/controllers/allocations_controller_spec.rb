require 'rails_helper'

RSpec.describe AllocationsController, type: :controller do
  context "user is group admin" do
    before do
      @membership = make_user_group_admin
      request.headers.merge!(user.create_new_auth_token)
    end

    context "valid params" do
      before do
        valid_params = {
          allocation: {
            group_id: @membership.group.id,
            user_id: @membership.member.id,
            amount: 420
          }
        }
        post :create, valid_params
        @found_allocation = Allocation.find_by(valid_params[:allocation])
      end

      it "creates allocation with specified params" do
        expect(@found_allocation).to be_truthy
      end

      it "returns allocation as json" do
        expect(parsed(response)["allocations"][0]["id"]).to eq(@found_allocation.id)
      end

      it "returns http status 'created'" do
        expect(response).to have_http_status(:created)
      end
    end

    context "invalid params" do
      before do
        invalid_params = {
          allocation: {
            group_id: @membership.group.id,
            user_id: @membership.member.id,
            amount: 0
          }
        }
        post :create, invalid_params
        @found_allocation = Allocation.find_by(invalid_params[:allocation])
      end

      it "does not create an allocation" do
        expect(@found_allocation).to be_nil
      end

      it "returns http status 400" do
        expect(response).to have_http_status(400)
      end
    end
  end

  context "user is not group admin" do
    before do
      membership = make_user_group_member
      request.headers.merge!(user.create_new_auth_token)
      valid_params = {
        allocation: {
          group_id: membership.group.id,
          user_id: membership.member.id,
          amount: 420
        }
      }
      post :create, valid_params
      @found_allocation = Allocation.find_by(valid_params[:allocation])
    end

    it "does not create an allocation" do
      expect(@found_allocation).to be_nil
    end

    it "returns http status 'forbidden'" do
      expect(response).to have_http_status(:forbidden)
    end
  end

  context "user not logged in" do
    it "returns http status 'unauthorized'" do
      membership = make_user_group_member
      post :create, {membership_id: membership.id, amount: 420}
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
