require 'rails_helper'

describe MembershipsController, :type => :controller do
  describe "#destroy" do
    before do
      make_user_group_member
      request.headers.merge!(user.create_new_auth_token)
      @membership = create(:membership, group: group)
    end

    context "group admin" do
      before do
        group.add_admin(user)
      end

      it "returns http status ok" do
        delete :destroy, {id: @membership.id}
        expect(response).to have_http_status(:ok)
      end
    end

    context "not group admin" do
      it "returns http status forbidden" do
        delete :destroy, {id: @membership.id}
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end