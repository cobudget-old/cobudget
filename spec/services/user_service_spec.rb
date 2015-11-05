require 'rails_helper'

describe "UserService" do
  describe "#fetch_recent_activity_for" do
    context "user has one membership" do
      before do
        @membership = make_user_group_member
        user.update(utc_offset: -480) # user is in oakland
        utc_offset_in_hours = user.utc_offset / 60
        oakland_6am_today_in_utc = (DateTime.now.in_time_zone(utc_offset_in_hours).beginning_of_day + 6.hours).utc
        oakland_6am_yesterday_in_utc = oakland_6am_today_in_utc - 1.day

        Timecop.freeze(oakland_6am_yesterday_in_utc - 1.hours) do
          create(:draft_bucket, group: group)
          create(:live_bucket, group: group)
          create(:funded_bucket, group: group)
        end

        Timecop.freeze(oakland_6am_yesterday_in_utc + 2.hours) do
          @d1 = create(:draft_bucket, group: group)
          @l1 = create(:live_bucket, group: group)
          @f1 = create(:funded_bucket, group: group)
        end

        Timecop.freeze(oakland_6am_yesterday_in_utc + 3.hours) do
          @d2 = create(:draft_bucket, group: group)
          @l2 = create(:live_bucket, group: group)
          @f2 = create(:funded_bucket, group: group)
        end

        Timecop.freeze(oakland_6am_today_in_utc + 1.hours) do
          create(:draft_bucket, group: group)
          create(:live_bucket, group: group)
          create(:funded_bucket, group: group)
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

    context "user has multiple memberships" do
      before do
        make_user_group_member
        user.update(utc_offset: -480)
        create(:membership, member: user)
        create(:membership, member: user)
        @recent_activity = UserService.fetch_recent_activity_for(user: user)
      end

      it "returns recent activity for every group user is a member of" do
        expect(@recent_activity.length).to eq(3)
      end
    end

    context "user does not have a utc_offset specified yet" do
      it "returns nil" do
        make_user_group_member
        user.update(utc_offset: nil)
        expect(UserService.fetch_recent_activity_for(user: user)).to be_nil
      end
    end
  end
end
