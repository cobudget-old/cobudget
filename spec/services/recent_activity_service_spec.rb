require 'rails_helper'

describe "RecentActivityService" do
  let(:current_time) { DateTime.now.utc }
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:membership) { create(:membership, member: user, group: group) }
  # notification_frequency set to 'hourly' by default
  let(:subscription_tracker) { user.subscription_tracker }

  before do
    Timecop.freeze(current_time - 70.minutes) do
      create(:allocation, user: user, group: group, amount: 20000)
      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)

      @bucket_user_participated_in = create(:bucket, group: group, target: 420, status: "live")
      create(:comment, user: user, bucket: @bucket_user_participated_in)

      @bucket_user_authored = create(:bucket, group: group, user: user, target: 420, status: "live")
      @bucket_user_authored_to_be_fully_funded = create(:bucket, group: group, user: user, target: 420, status: "live")
    end
  end

  after { Timecop.return }

  context "recent_activity exists" do
    before do
      # make some old activity
      Timecop.freeze(current_time - 70.minutes) do
        # create 1 comments on @bucket_user_participated_in
        create_list(:comment, 1, bucket: @bucket_user_participated_in)

        # create 1 comments on @bucket_user_authored
        create_list(:comment, 1, bucket: @bucket_user_authored)

        # create 1 contributions for @bucket_user_participated_in
        create_list(:contribution, 1, bucket: @bucket_user_participated_in)

        # create 1 contributions for @bucket_user_authored
        create_list(:contribution, 1, bucket: @bucket_user_authored)

        # create 1 contribution for@bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@bucket_user_authored_to_be_fully_funded)

        # create 1 new draft_buckets
        create_list(:bucket, 1, status: "draft", group: group, target: 420)

        # create 1 new live_buckets
        create_list(:bucket, 1, status: "live", group: group, target: 420)

        # create 1 new funded_buckets
        create_list(:bucket, 1, status: "live", group: group, target: 420).each do |bucket|
          create(:contribution, bucket: bucket, amount: 420)
        end
      end

      # make some new activity
      Timecop.freeze(current_time - 30.minutes) do
        # create 2 comments on @bucket_user_participated_in
        create_list(:comment, 2, bucket: @bucket_user_participated_in)

        # create 2 comments on @bucket_user_authored
        create_list(:comment, 2, bucket: @bucket_user_authored)

        # create 2 contributions for @bucket_user_participated_in
        create_list(:contribution, 2, bucket: @bucket_user_participated_in)

        # create 2 contributions for @bucket_user_authored
        create_list(:contribution, 2, bucket: @bucket_user_authored)

        # create 2 contributions for @bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@bucket_user_authored_to_be_fully_funded)
        create(:contribution,
          bucket:@bucket_user_authored_to_be_fully_funded,
          amount:@bucket_user_authored_to_be_fully_funded.amount_left
        )

        # create 2 new draft_buckets
        create_list(:bucket, 2, status: "draft", group: group, target: 420)

        # create 2 new live_buckets
        create_list(:bucket, 2, status: "live", group: group, target: 420)

        # create 2 new funded_buckets
        create_list(:bucket, 2, status: "live", group: group, target: 420).each do |bucket|
          create(:contribution, bucket: bucket, amount: 420)
        end
      end
    end

    context "user subscribed to all recent_activity" do
      it "prepares a hash of activity in all user's groups" do
        Timecop.freeze(current_time) do
          recent_activity = RecentActivityService.new(user: user)

          recent_activity_in_group = recent_activity.activity_for_all_groups[group]

          expect(recent_activity_in_group[:comments_on_buckets_user_participated_in].length).to eq(2)
          expect(recent_activity_in_group[:comments_on_buckets_user_authored].length).to eq(2)
          expect(recent_activity_in_group[:contributions_to_live_buckets_user_authored].length).to eq(2)
          expect(recent_activity_in_group[:contributions_to_live_buckets_user_participated_in].length).to eq(2)

          expect(recent_activity_in_group[:funded_buckets_user_authored].length).to eq(1)

          expect(recent_activity_in_group[:new_draft_buckets].length).to eq(2)
          expect(recent_activity_in_group[:new_live_buckets].length).to eq(2)
          expect(recent_activity_in_group[:new_funded_buckets].length).to eq(2)

          expect(recent_activity.is_present?).to eq(true)
        end
      end
    end

    context "user not subscribed to any recent_activity" do
      it "returns nil instead" do
        subscription_tracker.update(
          comments_on_buckets_user_authored: false,
          comments_on_buckets_user_participated_in: false,
          new_draft_buckets: false,
          new_live_buckets: false,
          new_funded_buckets: false,
          contributions_to_live_buckets_user_authored: false,
          contributions_to_live_buckets_user_participated_in: false,
          funded_buckets_user_authored: false
        )

        recent_activity = RecentActivityService.new(user: user)
        recent_activity_in_group = recent_activity.activity_for_all_groups[group]

        expect(recent_activity_in_group).to eq({
          comments_on_buckets_user_participated_in: nil,
          comments_on_buckets_user_authored: nil,
          contributions_to_live_buckets_user_authored: nil,
          funded_buckets_user_authored: nil,
          contributions_to_live_buckets_user_participated_in: nil,
          new_funded_buckets: nil,
          new_draft_buckets: nil,
          new_live_buckets: nil
        })

        expect(recent_activity.is_present?).to eq(false)
      end
    end
  end

  context "user subscribed to all recent_activity, but none exists" do
    it "returns nil instead" do
      recent_activity = RecentActivityService.new(user: user)
      recent_activity_in_group = recent_activity.activity_for_all_groups[group]

      expect(recent_activity_in_group).to eq({
        comments_on_buckets_user_participated_in: nil,
        comments_on_buckets_user_authored: nil,
        contributions_to_live_buckets_user_authored: nil,
        funded_buckets_user_authored: nil,
        contributions_to_live_buckets_user_participated_in: nil,
        new_funded_buckets: nil,
        new_draft_buckets: nil,
        new_live_buckets: nil
      })

      expect(recent_activity.is_present?).to eq(false)
    end
  end
end
