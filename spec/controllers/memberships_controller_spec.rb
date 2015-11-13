require 'rails_helper'

describe MembershipsController, :type => :controller do
  describe "#archive" do
    before do
      make_user_group_member
      request.headers.merge!(user.create_new_auth_token)
      @membership = create(:membership, group: group)
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