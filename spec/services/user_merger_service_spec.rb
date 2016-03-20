require 'rails_helper'

describe "UserMergerService" do
  describe "#merge" do
    before do
      @user_to_keep = create(:user, name: 'User Keep')
      @user_to_kill = create(:user, name: 'User Kill')

      @membership_to_transfer = create(:membership, member: @user_to_kill)
      @group = @membership_to_transfer.group
      @allocation_to_transfer =   create(:allocation, group: @group, user: @user_to_kill)
      @contribution_to_transfer = create(:contribution,              user: @user_to_kill)
      @bucket_to_transfer =       create(:bucket,     group: @group, user: @user_to_kill)
      @comment_to_transfer =      create(:comment,                   user: @user_to_kill)
    end

    context "transfering memebership is going to double up membership for a group," do
      before do 
        @existing_membership = create(:membership, member: @user_to_keep, group: @group)
      end 

      context "they're both just normal users," do
        it "deletes the membership of the user_to_kill" do
          expect(Membership.where(group: @group, member: [@user_to_keep, @user_to_kill]).count).to eq 2
          UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

          expect(Membership.where(group: @group, member: [@user_to_keep, @user_to_kill]).count).to eq 1
        end
      end

      context "the membership of the to_keep is archived but the to_kill membership is not," do
        it "it moves the archived_at: nil to the to_keep membership, them destroys the to_kill one " do
          @existing_membership.update_attributes(archived_at: Time.now)

          UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)
          
          @existing_membership.reload
          remaining_membership = Membership.where(group: @group, member: [@user_to_keep, @user_to_kill])
          expect(remaining_membership).to eq [@existing_membership]
          expect(@existing_membership.archived_at).to eq(nil)
        end
      end

      context "the to_kill membership is an admin" do 
        it "it moves the is_admin: true to the to_keep membership, then destroys the to_kill one" do
          @membership_to_transfer.update_attributes(is_admin: true)

          UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

          @existing_membership.reload
          remaining_membership = Membership.where(group: @group, member: [@user_to_keep, @user_to_kill])
          expect(remaining_membership).to eq [@existing_membership]
          expect(@existing_membership.is_admin).to eq(true)
        end
      end

    end

    context "transfering membership won't double up membership" do
      it "moves all memberships" do
        UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

        expect(@membership_to_transfer.reload.member).to eq(@user_to_keep)
      end
    end

    it "moves all allocations" do
      UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@allocation_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "moves all contributions" do
      UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@contribution_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "moves all buckets" do
      UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@bucket_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "moves all comments" do 
      UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@comment_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "destroys the user_to_kill" do
      expect(@user_to_kill).to receive(:destroy)

      UserMergerService.merge( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)
    end

    #it "raises an error if the user_to_kill is an admin" do

    #end


  end
end

