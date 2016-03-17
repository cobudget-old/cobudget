require 'rails_helper'

describe "RecentActivityService" do
  let(:current_time) { DateTime.now.utc }
  let(:user) { create(:user) }
  let(:group) { create(:group) }
  let(:membership) { create(:membership, member: user, group: group) }
  # notification_frequency set to 'hourly' by default
  let(:subscription_tracker) { user.subscription_tracker }
  let(:bucket_that_user_has_participated_in) { create(:bucket, group: group) }
  let(:bucket_that_user_has_authored) { create(:bucket, group: group, user: user) }
  let(:other_bucket_that_user_has_authored) { create(:bucket, group: group, user: user) }

  before do
    create(:allocation, user: user, group: group, amount: 20000)
    subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)
    create(:comment, user: user, bucket: bucket_that_user_has_participated_in)
  end

  after { Timecop.return }

  context "recent_activity exists" do
    before do
      # make some old activity
      Timecop.freeze(current_time - 70.minutes) do
        # comments_on_buckets_user_participated_in
        create_list(:comment, 2, bucket: bucket_that_user_has_participated_in)

        # comments_on_users_buckets
        create_list(:comment, 2, bucket: bucket_that_user_has_authored)

        # contributions_to_buckets_user_participated_in
        create_list(:contribution, 2, bucket: bucket_that_user_has_participated_in)

        # contributions_to_users_buckets
        create_list(:contribution, 2, bucket: bucket_that_user_has_authored)

        # users_buckets_fully_funded
        bucket_that_user_has_authored.update(status: 'funded')

        # new_draft_buckets
        create_list(:bucket, 2, status: 'draft', group: group)

        # new_live_buckets
        create_list(:bucket, 2, status: 'live', group: group)

        # new_funded_buckets
        create_list(:bucket, 2, status: 'funded', group: group)
      end

      # make some new activity
      Timecop.freeze(current_time - 30.minutes) do
        # comments_on_buckets_user_participated_in
        create_list(:comment, 1, bucket: bucket_that_user_has_participated_in)

        # comments_on_users_buckets
        create_list(:comment, 1, bucket: bucket_that_user_has_authored)

        # contributions_to_buckets_user_participated_in
        create_list(:contribution, 1, bucket: bucket_that_user_has_participated_in)

        # contributions_to_users_buckets
        create_list(:contribution, 1, bucket: bucket_that_user_has_authored)

        # users_buckets_fully_funded
        other_bucket_that_user_has_authored.update(status: 'funded')

        # new_draft_buckets
        create_list(:bucket, 1, status: 'draft', group: group)

        # new_live_buckets
        create_list(:bucket, 1, status: 'live', group: group)

        # new_funded_buckets
        create_list(:bucket, 1, status: 'funded', group: group)
      end
    end

    context "user subscribed to all recent_activity" do
      it "returns all recent_activity as a hash" do
        recent_activity = RecentActivityService.new(user: user)
        activity = recent_activity.for_group(group)

        # comments_on_buckets_user_participated_in (excludes comments made on buckets user has authored)
        expect(activity[:comments_on_buckets_user_participated_in].length).to eq(1)

        # comments_on_users_buckets
        expect(activity[:comments_on_users_buckets].length).to eq(1)

        # comments_on_buckets_user_participated_in (excludes contributions made on buckets user has authored)
        expect(activity[:contributions_to_buckets_user_participated_in].length).to eq(1)

        # contributions_to_users_buckets
        expect(activity[:contributions_to_users_buckets].length).to eq(1)

        # users_buckets_fully_funded
        expect(activity[:users_buckets_fully_funded]).to include(other_bucket_that_user_has_authored)
        expect(activity[:users_buckets_fully_funded]).not_to include(bucket_that_user_has_authored)

        # new_draft_buckets
        expect(activity[:new_draft_buckets].length).to eq(1)

        # new_live_buckets
        expect(activity[:new_live_buckets].length).to eq(1)

        # other_buckets_fully_funded (excludes those authored by user)
        expect(activity[:other_buckets_fully_funded].length).to eq(1)

        expect(recent_activity.is_present?).to eq(true)
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
          your_bucket_fully_funded: false,
          recent_activity_last_fetched_at: false
        )

        recent_activity = RecentActivityService.new(user: user)

        expect(recent_activity.for_group(group)).to eq({
          comments_on_buckets_user_participated_in: nil,
          comments_on_users_buckets: nil,
          contributions_to_users_buckets: nil,
          contributions_to_buckets_user_participated_in: nil,
          users_buckets_fully_funded: nil,
          new_draft_buckets: nil,
          new_live_buckets: nil,
          other_buckets_fully_funded: nil
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
        comments_on_users_buckets: nil,
        contributions_to_users_buckets: nil,
        contributions_to_buckets_user_participated_in: nil,
        users_buckets_fully_funded: nil,
        new_draft_buckets: nil,
        new_live_buckets: nil,
        other_buckets_fully_funded: nil
      })

      expect(recent_activity.is_present?).to eq(false)
    end
  end
end
