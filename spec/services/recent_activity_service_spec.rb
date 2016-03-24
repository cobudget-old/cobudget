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
      @bucket_user_participated_in_to_be_fully_funded = create(:bucket, group: group, target: 420, status: "live")
      create(:contribution, user: user, bucket: @bucket_user_participated_in_to_be_fully_funded)

      @bucket_user_authored = create(:bucket, group: group, user: user, target: 420, status: "live")
      @bucket_user_authored_to_be_fully_funded = create(:bucket, group: group, user: user, target: 420, status: "live")
    end
  end

  after { Timecop.return }

  context "recent_activity exists" do
    before do
      # make some old activity
      Timecop.freeze(current_time - 70.minutes) do
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

        # create 2 contributions for @bucket_user_participated_in_to_be_fully_funded
        create(:contribution, bucket: @bucket_user_participated_in_to_be_fully_funded)
        create(:contribution,
          bucket: @bucket_user_participated_in_to_be_fully_funded,
          amount: @bucket_user_participated_in_to_be_fully_funded.amount_left
        )

        # create 2 contributions for@bucket_user_authored_to_be_fully_funded
        create(:contribution, bucket:@bucket_user_authored_to_be_fully_funded)
        create(:contribution,
          bucket:@bucket_user_authored_to_be_fully_funded,
          amount:@bucket_user_authored_to_be_fully_funded.amount_left
        )

        # create 2 new draft_buckets
        create_list(:bucket, 2, status: "draft", group: group, target: 420)

        # create 2 new live_buckets
        create_list(:bucket, 2, status: "live", group: group, target: 420)
      end
    end

    context "user subscribed to all recent_activity" do
      it "returns all recent_activity as a hash" do
        Timecop.freeze(current_time) do
          recent_activity = RecentActivityService.new(user: user)
          activity = recent_activity.for_group(group)
          expect(activity[:comments_on_buckets_user_participated_in].length).to eq(2)
          expect(activity[:comments_on_buckets_user_authored].length).to eq(2)

          expect(activity[:contributions_to_live_buckets_user_authored].length).to eq(2)

          expect(activity[:contributions_to_funded_buckets_user_authored].length).to eq(2)
          expect(activity[:contributions_to_live_buckets_user_participated_in].length).to eq(2)
          expect(activity[:contributions_to_funded_buckets_user_participated_in].length).to eq(2)
          expect(activity[:new_draft_buckets].length).to eq(2)
          expect(activity[:new_live_buckets].length).to eq(2)
        end
      end
    end

    context "user not subscribed to any recent_activity" do
      it "returns nil instead" do
        subscription_tracker.update(
          comment_on_your_bucket: false,
          comment_on_bucket_you_participated_in: false,
          bucket_idea_created: false,
          bucket_started_funding: false,
          bucket_fully_funded: false,
          funding_for_your_bucket: false,
          funding_for_a_bucket_you_participated_in: false,
          your_bucket_fully_funded: false
        )

        recent_activity = RecentActivityService.new(user: user)

        expect(recent_activity.for_group(group)).to eq({
          comments_on_buckets_user_participated_in: nil,
          comments_on_buckets_user_authored: nil,
          contributions_to_live_buckets_user_authored: nil,
          contributions_to_funded_buckets_user_authored: nil,
          contributions_to_live_buckets_user_participated_in: nil,
          contributions_to_funded_buckets_user_participated_in: nil,
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

      expect(recent_activity.for_group(group)).to eq({
        comments_on_buckets_user_participated_in: nil,
        comments_on_buckets_user_authored: nil,
        contributions_to_live_buckets_user_authored: nil,
        contributions_to_funded_buckets_user_authored: nil,
        contributions_to_live_buckets_user_participated_in: nil,
        contributions_to_funded_buckets_user_participated_in: nil,
        new_draft_buckets: nil,
        new_live_buckets: nil
      })

      expect(recent_activity.is_present?).to eq(false)
    end
  end
end
