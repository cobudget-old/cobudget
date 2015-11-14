require 'rails_helper'

describe MembershipsController, :type => :controller do
  def parsed(response)
    JSON.parse(response.body)
  end

  describe "#index" do
    context "user logged in" do
      before do
        make_user_group_member
        request.headers.merge!(user.create_new_auth_token)
        create_list(:membership, 5, group: group)
        create_list(:membership, 2, group: group, archived_at: DateTime.now.utc - 5.days)
        get :index, group_id: group.id
      end

      it "returns http status success" do
        expect(response).to have_http_status(:success)
      end

      it "returns all active memberships for the group" do
        expect(parsed(response)["memberships"].length).to eq(6)
      end
    end

    context "user not logged in" do
      it "returns http status unauthorized" do
        get :index, group_id: group.id
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "#archive" do
    before do
      @membership = make_user_group_member
      request.headers.merge!(user.create_new_auth_token)
    end

    context "group admin" do
      before do
        group.add_admin(user)
        post :archive, {id: @membership.id}
        @membership.reload
      end

      it "returns http status ok" do
        expect(response).to have_http_status(:ok)
      end 

      it "sets user's archived_at to current time" do
        expect(@membership.archived_at).to be_truthy
      end
    end

    context "not group admin" do
      it "returns http status forbidden" do
        post :archive, {id: @membership.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end