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
end
