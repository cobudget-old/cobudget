require 'rails_helper'

describe MembershipsController, :type => :controller do
  context "admin" do
    before do
      make_user_group_admin
      request.headers.merge!(user.create_new_auth_token)
    end

    describe "#destroy" do
      before do
        @other_user = create(:user)
        @membership = create(:membership, member: @other_user, group: group)

        @other_group = create(:group)
        @other_membership = create(:membership, member: @other_user, group: @other_group)

        @group_bucket = create(:bucket, group: group)
        @other_group_bucket = create(:bucket, group: @other_group)
      end

      it "destroys membership" do
        delete :destroy, {id: @membership.id}

        expect(Membership.find_by_id(@membership.id)).to be_nil
      end

      it "destroys member's allocations within membership's group" do
        create_list(:allocation, 3, group: group, user: @other_user)
        create_list(:allocation, 2, group: @other_group, user: @other_user)
        delete :destroy, {id: @membership.id}

        expect(Allocation.where(user: @other_user, group: group).length).to eq(0)
        expect(Allocation.where(user: @other_user, group: @other_group).length).to eq(2)
      end

      it "destroys all member's buckets within the membership's group" do
        create_list(:bucket, 4, group: group, user: user)
        create_list(:bucket, 2, group: group, user: @other_user)
        create_list(:bucket, 5, group: @other_group, user: user)
        create_list(:bucket, 3, group: @other_group, user: @other_user)
        delete :destroy, {id: @membership.id}

        expect(Bucket.where(group: group, user: @other_user).length).to eq(0)
        expect(Bucket.where(group: @other_group, user: @other_user).length).to eq(3)
      end

      it "destroys member's comments within membership's group" do
        create_list(:comment, 3, user: @other_user, bucket: @group_bucket)
        create_list(:comment, 2, user: user, bucket: @group_bucket)
        create_list(:comment, 4, user: @other_user, bucket: @other_group_bucket)
        create_list(:comment, 3, user: user, bucket: @other_group_bucket)
        delete :destroy, {id: @membership.id}

        expect(@group_bucket.comments.length).to eq(2)
        expect(@other_group_bucket.comments.length).to eq(7)
      end

      it "destroys member's contributions within membership's group" do
        create_list(:contribution, 3, user: @other_user, bucket: @group_bucket)
        create_list(:contribution, 2, user: user, bucket: @group_bucket)
        create_list(:contribution, 2, user: @other_user, bucket: @other_group_bucket)
        create_list(:contribution, 1, user: user, bucket: @other_group_bucket)
        delete :destroy, {id: @membership.id}

        expect(@group_bucket.contributions.length).to eq(2)
        expect(@other_group_bucket.contributions.length).to eq(3)
      end

      context "user has only one membership" do
        it "also destroys member" do
          @other_membership.destroy
          delete :destroy, {id: @membership.id}

          expect(User.find_by_id(@other_user.id)).to be_nil
        end
      end
    end
  end
end