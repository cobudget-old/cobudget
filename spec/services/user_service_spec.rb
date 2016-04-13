require 'rails_helper'

describe "UserService" do
  describe "#fetch_recent_activity_for" do
    context "user has one membership in a group with recent activity" do
      before do
        @membership = make_user_group_member
        user.update(utc_offset: -480) # user is in oakland
        utc_offset_in_hours = user.utc_offset / 60
        oakland_6am_today_in_utc = (DateTime.now.in_time_zone(utc_offset_in_hours).beginning_of_day + 6.hours).utc
        oakland_6am_yesterday_in_utc = oakland_6am_today_in_utc - 1.day

        Timecop.freeze(oakland_6am_yesterday_in_utc - 1.hours) do
          create(:bucket, group: group, status: "draft")
          create(:bucket, group: group, status: "live")
          create(:bucket, group: group, status: "funded")
        end

        Timecop.freeze(oakland_6am_yesterday_in_utc + 2.hours) do
          @d1 = create(:bucket, group: group, status: "draft")
          @l1 = create(:bucket, group: group, status: "live")
          @f1 = create(:bucket, group: group, status: "funded")
        end

        Timecop.freeze(oakland_6am_yesterday_in_utc + 3.hours) do
          @d2 = create(:bucket, group: group, status: "draft")
          @l2 = create(:bucket, group: group, status: "live")
          @f2 = create(:bucket, group: group, status: "funded")
        end

        Timecop.freeze(oakland_6am_today_in_utc + 1.hours) do
          create(:bucket, group: group, status: "draft")
          create(:bucket, group: group, status: "live")
          create(:bucket, group: group, status: "funded")
        end

        @recent_activity = UserService.fetch_recent_activity_for(user: user)
      end

      after do
        Timecop.return
      end

      it "returns users group" do
        expect(@recent_activity[0][:group]).to eq(group)
      end

      it "returns users membership" do
        expect(@recent_activity[0][:membership]).to eq(@membership)
      end

      it "returns all draft buckets created between 6am yesterday and 6am today (user's local time)" do
        expect(@recent_activity[0][:draft_buckets].length).to eq(2)
        expect(@recent_activity[0][:draft_buckets]).to include(@d1, @d2)
      end

      it "returns all buckets that became live between 6am yesterday and 6am today (user's local time)" do
        expect(@recent_activity[0][:live_buckets].length).to eq(2)
        expect(@recent_activity[0][:live_buckets]).to include(@l1, @l2)
      end

      it "returns all buckets that became funded between 6am yesterday and 6am today (user's local time)" do
        expect(@recent_activity[0][:funded_buckets].length).to eq(2)
        expect(@recent_activity[0][:funded_buckets]).to include(@f1, @f2)
      end
    end

    context "user has multiple memberships in groups with recent activity" do
      before do
        make_user_group_member
        user.update(utc_offset: -480)
        utc_offset_in_hours = user.utc_offset / 60
        oakland_6am_today_in_utc = (DateTime.now.in_time_zone(utc_offset_in_hours).beginning_of_day + 6.hours).utc
        oakland_6am_yesterday_in_utc = oakland_6am_today_in_utc - 1.day

        membership1 = create(:membership, member: user)
        membership2 = create(:membership, member: user)
        group1 = membership1.group
        group2 = membership2.group

        Timecop.freeze(oakland_6am_yesterday_in_utc + 2.hours) do
          create(:bucket, group: group1, status: "draft")
          create(:bucket, group: group1, status: "live")
          create(:bucket, group: group1, status: "funded")
        end

        Timecop.freeze(oakland_6am_yesterday_in_utc + 3.hours) do
          create(:bucket, group: group2, status: "draft")
          create(:bucket, group: group2, status: "live")
          create(:bucket, group: group2, status: "funded")
        end

        @recent_activity = UserService.fetch_recent_activity_for(user: user)
      end

      it "returns recent activity for every group user is a member of" do
        expect(@recent_activity.length).to eq(2)
      end
    end

    context "user has some archived memberships" do
      before do
        make_user_group_member
        user.update(utc_offset: -480)
        utc_offset_in_hours = user.utc_offset / 60
        oakland_6am_today_in_utc = (DateTime.now.in_time_zone(utc_offset_in_hours).beginning_of_day + 6.hours).utc
        oakland_6am_yesterday_in_utc = oakland_6am_today_in_utc - 1.day

        membership1 = create(:membership, member: user)
        membership2 = create(:membership, member: user, archived_at: DateTime.now.utc - 5.days)
        group1 = membership1.group
        group2 = membership2.group

        Timecop.freeze(oakland_6am_yesterday_in_utc + 2.hours) do
          create(:bucket, group: group1, status: "draft")
          create(:bucket, group: group1, status: "live")
          create(:bucket, group: group1, status: "funded")
        end

        Timecop.freeze(oakland_6am_yesterday_in_utc + 3.hours) do
          create(:bucket, group: group2, status: "draft")
          create(:bucket, group: group2, status: "live")
          create(:bucket, group: group2, status: "funded")
        end

        @recent_activity = UserService.fetch_recent_activity_for(user: user)
      end

      it "returns recent activity for every group user is a member of" do
        expect(@recent_activity.length).to eq(1)
      end
    end

    context "user does not have a utc_offset specified yet" do
      it "returns nil" do
        make_user_group_member
        user.update(utc_offset: nil)
        expect(UserService.fetch_recent_activity_for(user: user)).to be_nil
      end
    end

    context "there is no recent activity" do
      it "returns nil" do
        make_user_group_member
        user.update(utc_offset: -480)
        expect(UserService.fetch_recent_activity_for(user: user)).to be_nil
      end
    end
  end

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

    context "admin submits same user to both keep and kill" do
      it "does not kill the user" do
        UserService.merge_users(user_to_keep: @user_to_keep, user_to_kill: @user_to_keep)

        @user_to_keep.reload
        expect(@user_to_keep.persisted?).to be true
      end
    end

    context "transfering memebership is going to double up membership for a group," do
      before do
        @existing_membership = create(:membership, member: @user_to_keep, group: @group)
      end

      context "they're both just normal memberships," do
        it "deletes the membership of the user_to_kill" do
          expect(Membership.where(group: @group, member: [@user_to_keep, @user_to_kill]).count).to eq 2
          UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

          expect(Membership.where(group: @group, member: [@user_to_keep, @user_to_kill]).count).to eq 1
        end
      end

      context "the membership of the to_keep is archived but the to_kill membership is not," do
        it "it moves the archived_at: nil to the to_keep membership, them destroys the to_kill one " do
          @existing_membership.update_attributes(archived_at: Time.now)

          UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

          @existing_membership.reload
          remaining_membership = Membership.where(group: @group, member: [@user_to_keep, @user_to_kill])
          expect(remaining_membership).to eq [@existing_membership]
          expect(@existing_membership.archived_at).to eq(nil)
        end
      end

      context "the to_kill membership is an admin" do
        it "it moves the is_admin: true to the to_keep membership, then destroys the to_kill one" do
          @membership_to_transfer.update_attributes(is_admin: true)

          UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

          @existing_membership.reload
          remaining_membership = Membership.where(group: @group, member: [@user_to_keep, @user_to_kill])
          expect(remaining_membership).to eq [@existing_membership]
          expect(@existing_membership.is_admin).to eq(true)
        end
      end

    end

    context "transfering membership won't double up membership" do
      it "moves all memberships" do
        UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

        expect(@membership_to_transfer.reload.member).to eq(@user_to_keep)
      end
    end

    it "moves all allocations" do
      UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@allocation_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "moves all contributions" do
      UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@contribution_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "moves all buckets" do
      UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@bucket_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "moves all comments" do
      UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)

      expect(@comment_to_transfer.reload.user).to eq(@user_to_keep)
    end

    it "destroys the user_to_kill" do
      expect(@user_to_kill).to receive(:destroy)

      UserService.merge_users( user_to_keep: @user_to_keep, user_to_kill: @user_to_kill)
    end
  end
end
