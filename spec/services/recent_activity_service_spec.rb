require 'rails_helper'

describe "RecentActivityService" do
  let!(:current_time) { DateTime.now.utc }
  let!(:user) { create(:user) }
  let!(:group1) { create(:group) }
  let!(:membership1) { create(:membership, member: user, group: group1) }
  let!(:group2) { create(:group) }
  let!(:membership2) { create(:membership, member: user, group: group2) }
  # notification_frequency set to 'hourly' by default
  let!(:subscription_tracker) { user.subscription_tracker }

  before do
    Timecop.freeze(current_time - 70.minutes) do
      create(:allocation, user: user, group: group1, amount: 20000)
      create(:allocation, user: user, group: group2, amount: 20000)
      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)

      @group1_bucket_user_participated_in = create(:bucket, group: group1, target: 420, status: "live")
      create(:comment, user: user, bucket: @group1_bucket_user_participated_in)

      @group2_bucket_user_participated_in = create(:bucket, group: group2, target: 420, status: "live")
      create(:comment, user: user, bucket: @group2_bucket_user_participated_in)

      @group1_bucket_user_authored = create(:bucket, group: group1, user: user, target: 420, status: "live")
      @group2_bucket_user_authored = create(:bucket, group: group2, user: user, target: 420, status: "live")

      @group1_bucket_user_authored_to_be_fully_funded = create(:bucket, group: group1, user: user, target: 420, status: "live")
      @group2_bucket_user_authored_to_be_fully_funded = create(:bucket, group: group2, user: user, target: 420, status: "live")
    end
  end

  after { Timecop.return }

  context "recent_activity exists" do
    before do
      # make some old activity
      Timecop.freeze(current_time - 70.minutes) do
        # for group1 ...

        # create 1 comments on @group1_bucket_user_participated_in
        create_list(:comment, 1, bucket: @group1_bucket_user_participated_in)
        # create 1 comments on @group1_bucket_user_authored
        create_list(:comment, 1, bucket: @group1_bucket_user_authored)
        # create 1 contributions for @group1_bucket_user_participated_in
        create_list(:contribution, 1, bucket: @group1_bucket_user_participated_in)
        # create 1 contributions for @group1_bucket_user_authored
        create_list(:contribution, 1, bucket: @group1_bucket_user_authored)
        # create 1 contribution for@group1_bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@group1_bucket_user_authored_to_be_fully_funded)
        # create 1 new draft_buckets
        create_list(:bucket, 1, status: "draft", group: group1, target: 420)
        # create 1 new live_buckets
        create_list(:bucket, 1, status: "live", group: group1, target: 420)
        # create 1 new funded_buckets
        create_list(:bucket, 1, status: "live", group: group1, target: 420).each do |bucket|
          create(:contribution, bucket: bucket, amount: 420)
        end

        # and for group2 ...
        # create 2 comments on @group2_bucket_user_participated_in
        create_list(:comment, 2, bucket: @group2_bucket_user_participated_in)
        # create 2 comments on @group2_bucket_user_authored
        create_list(:comment, 2, bucket: @group2_bucket_user_authored)
        # create 2 contributions for @group2_bucket_user_participated_in
        create_list(:contribution, 2, bucket: @group2_bucket_user_participated_in)
        # create 2 contributions for @group2_bucket_user_authored
        create_list(:contribution, 2, bucket: @group2_bucket_user_authored)
        # create 2 contribution for@group2_bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@group2_bucket_user_authored_to_be_fully_funded)
        # create 2 new draft_buckets
        create_list(:bucket, 2, status: "draft", group: group2, target: 420)
        # create 2 new live_buckets
        create_list(:bucket, 2, status: "live", group: group2, target: 420)
        # create 2 new funded_buckets
        create_list(:bucket, 2, status: "live", group: group2, target: 420).each do |bucket|
          create(:contribution, bucket: bucket, amount: 420)
        end
      end

      # make some new activity
      Timecop.freeze(current_time - 30.minutes) do
        # for group1 ...

        # create 2 comments on @group1_bucket_user_participated_in
        create_list(:comment, 2, bucket: @group1_bucket_user_participated_in)
        # create 2 comments on @group1_bucket_user_authored
        create_list(:comment, 2, bucket: @group1_bucket_user_authored)
        # create 2 contributions for @group1_bucket_user_participated_in
        create_list(:contribution, 2, bucket: @group1_bucket_user_participated_in)
        # create 2 contributions for @group1_bucket_user_authored
        create_list(:contribution, 2, bucket: @group1_bucket_user_authored)
        # create 2 contributions for @group1_bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@group1_bucket_user_authored_to_be_fully_funded)
        create(:contribution,
          bucket:@group1_bucket_user_authored_to_be_fully_funded,
          amount:@group1_bucket_user_authored_to_be_fully_funded.amount_left
        )
        # create 2 new draft_buckets
        create_list(:bucket, 2, status: "draft", group: group1, target: 420)
        # create 2 new live_buckets
        create_list(:bucket, 2, status: "live", group: group1, target: 420)
        # create 2 new funded_buckets
        create_list(:bucket, 2, status: "live", group: group1, target: 420).each do |bucket|
          create(:contribution, bucket: bucket, amount: 420)
        end

        # and for group2 ...

        # create 1 comments on @group2_bucket_user_participated_in
        create_list(:comment, 1, bucket: @group2_bucket_user_participated_in)
        # create 1 comments on @group2_bucket_user_authored
        create_list(:comment, 1, bucket: @group2_bucket_user_authored)
        # create 1 contributions for @group2_bucket_user_participated_in
        create_list(:contribution, 1, bucket: @group2_bucket_user_participated_in)
        # create 1 contributions for @group2_bucket_user_authored
        create_list(:contribution, 1, bucket: @group2_bucket_user_authored)
        # create 1 contributions for @group2_bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@group2_bucket_user_authored_to_be_fully_funded)
        create(:contribution,
          bucket:@group2_bucket_user_authored_to_be_fully_funded,
          amount:@group2_bucket_user_authored_to_be_fully_funded.amount_left
        )
        # create 1 new draft_buckets
        create_list(:bucket, 1, status: "draft", group: group2, target: 420)
        # create 1 new live_buckets
        create_list(:bucket, 1, status: "live", group: group2, target: 420)
        # create 1 new funded_buckets
        create_list(:bucket, 1, status: "live", group: group2, target: 420).each do |bucket|
          create(:contribution, bucket: bucket, amount: 420)
        end
      end
    end

    context "user subscribed to all recent_activity" do
      it "prepares `activity_for_all_groups`, an array of recent_activity hashes for each of the user's groups" do
        Timecop.freeze(current_time) do
          recent_activity = RecentActivityService.new(user: user)

          recent_activity_in_group1 = recent_activity.activity_for_all_groups.first

          expect(recent_activity_in_group1[:group]).to eq(group1)
          expect(recent_activity_in_group1[:comments_on_buckets_user_participated_in].length).to eq(2)
          expect(recent_activity_in_group1[:comments_on_buckets_user_authored].length).to eq(2)
          expect(recent_activity_in_group1[:contributions_to_live_buckets_user_authored].length).to eq(2)
          expect(recent_activity_in_group1[:contributions_to_live_buckets_user_participated_in].length).to eq(2)
          expect(recent_activity_in_group1[:funded_buckets_user_authored].length).to eq(1)
          expect(recent_activity_in_group1[:new_draft_buckets].length).to eq(2)
          expect(recent_activity_in_group1[:new_live_buckets].length).to eq(2)
          expect(recent_activity_in_group1[:new_funded_buckets].length).to eq(2)

          recent_activity_in_group2 = recent_activity.activity_for_all_groups.last

          expect(recent_activity_in_group2[:group]).to eq(group2)
          expect(recent_activity_in_group2[:comments_on_buckets_user_participated_in].length).to eq(1)
          expect(recent_activity_in_group2[:comments_on_buckets_user_authored].length).to eq(1)
          expect(recent_activity_in_group2[:contributions_to_live_buckets_user_authored].length).to eq(1)
          expect(recent_activity_in_group2[:contributions_to_live_buckets_user_participated_in].length).to eq(1)
          expect(recent_activity_in_group2[:funded_buckets_user_authored].length).to eq(1)
          expect(recent_activity_in_group2[:new_draft_buckets].length).to eq(1)
          expect(recent_activity_in_group2[:new_live_buckets].length).to eq(1)
          expect(recent_activity_in_group2[:new_funded_buckets].length).to eq(1)

          expect(recent_activity.is_present?).to eq(true)
        end
      end
    end

    context "user not subscribed to any recent_activity" do
      it "`activity_for_all_groups` is an empty array" do
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

        expect(recent_activity.activity_for_all_groups).to be_empty
        expect(recent_activity.is_present?).to eq(false)
      end
    end
  end

  context "user subscribed to all recent_activity, but none exists" do
    it "returns nil instead" do
      recent_activity = RecentActivityService.new(user: user)

      expect(recent_activity.activity_for_all_groups).to be_empty
      expect(recent_activity.is_present?).to eq(false)
    end
  end
end
