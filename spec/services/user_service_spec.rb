require 'rails_helper'

describe "UserService" do
  describe "recent_activity_for(user:)" do
    let!(:current_time) { DateTime.now.utc }
    let!(:user) { create(:user) }
    let!(:group1) { create(:group) }
    let!(:group2) { create(:group) }
    let!(:membership1) { create(:membership, member: user, group: group1) }
    let!(:membership2) { create(:membership, member: user, group: group2) }
    # notification_frequency set to 'hourly' by default
    let!(:subscription_tracker) { user.subscription_tracker }

    let!(:group1_bucket_that_user_has_participated_in) { create(:bucket, group: group1) }
    let!(:group2_bucket_that_user_has_participated_in) { create(:bucket, group: group2) }

    let!(:group1_bucket_that_user_has_authored) { create(:bucket, group: group1, user: user) }
    let!(:group2_bucket_that_user_has_authored) { create(:bucket, group: group2, user: user) }

    before do
      create(:allocation, user: user, group: group1, amount: 20000)
      create(:allocation, user: user, group: group2, amount: 20000)

      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)
      create(:comment, user: user, bucket: group1_bucket_that_user_has_participated_in)
      create(:contribution, user: user, bucket: group2_bucket_that_user_has_participated_in)

      user.reload

      # make some old activity
      Timecop.freeze(current_time - 70.minutes) do
        create_list(:comment, 2, bucket: group1_bucket_that_user_has_participated_in)
        create_list(:comment, 1, bucket: group2_bucket_that_user_has_participated_in)
      end

      # make some new activity
      Timecop.freeze(current_time - 30.minutes) do
        create_list(:comment, 1, bucket: group1_bucket_that_user_has_participated_in)
        create_list(:comment, 2, bucket: group2_bucket_that_user_has_participated_in)
      end
    end

    after { Timecop.return }

    context "user is subscribed to all activity" do
      it "returns all recent_activity as a hash" do
        recent_activity = UserService.fetch_recent_activity_for(user: user)
        group1_recent_activity = recent_activity[group1]
        group2_recent_activity = recent_activity[group2]
        expect(group1_recent_activity[:comments_on_buckets_user_participated_in].length).to eq(1)
        expect(group2_recent_activity[:comments_on_buckets_user_participated_in].length).to eq(2)
      end
    end
  end
end
