require 'rails_helper'

describe "RecentActivityService" do
  let(:current_time) { DateTime.now.utc }
  let(:user) { create(:user) }
  let(:group1) { create(:group) }
  let(:group2) { create(:group) }
  let(:membership1) { create(:membership, member: user, group: group1) }
  let(:membership2) { create(:membership, member: user, group: group2) }
  # notification_frequency set to 'hourly' by default
  let(:subscription_tracker) { user.subscription_tracker }

  let(:group1_bucket_that_user_has_participated_in) { create(:bucket, group: group1) }
  let(:group2_bucket_that_user_has_participated_in) { create(:bucket, group: group2) }

  let(:group1_bucket_that_user_has_authored) { create(:bucket, group: group1, user: user) }
  let(:group2_bucket_that_user_has_authored) { create(:bucket, group: group2, user: user) }
  let(:other_group1_bucket_that_user_has_authored) { create(:bucket, group: group1, user: user) }
  let(:other_group2_bucket_that_user_has_authored) { create(:bucket, group: group2, user: user) }

  before do
    create(:allocation, user: user, group: group1, amount: 20000)
    create(:allocation, user: user, group: group2, amount: 20000)
    subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)
    create(:comment, user: user, bucket: group1_bucket_that_user_has_participated_in)
    create(:contribution, user: user, bucket: group2_bucket_that_user_has_participated_in)
  end

  after { Timecop.return }

  context "recent_activity exists" do
    before do
      # make some old activity
      Timecop.freeze(current_time - 70.minutes) do
        # comments_on_buckets_user_participated_in
        create_list(:comment, 2, bucket: group1_bucket_that_user_has_participated_in)
        create_list(:comment, 1, bucket: group2_bucket_that_user_has_participated_in)

        # comments_on_users_buckets
        create_list(:comment, 2, bucket: group1_bucket_that_user_has_authored)
        create_list(:comment, 1, bucket: group2_bucket_that_user_has_authored)

        # contributions_to_users_buckets
        create_list(:contribution, 2, bucket: group1_bucket_that_user_has_authored)
        create_list(:contribution, 1, bucket: group2_bucket_that_user_has_authored)

        # contributions_to_buckets_user_participated_in
        create_list(:contribution, 2, bucket: group1_bucket_that_user_has_participated_in)
        create_list(:contribution, 1, bucket: group2_bucket_that_user_has_participated_in)

        # users_buckets_fully_funded
        group1_bucket_that_user_has_authored.update(status: 'funded')
        other_group2_bucket_that_user_has_authored.update(status: 'funded')

        # new_draft_buckets
        create_list(:bucket, 2, status: 'draft', group: group1)
        create_list(:bucket, 1, status: 'draft', group: group2)

        # new_live_buckets
        create_list(:bucket, 2, status: 'live', group: group1)
        create_list(:bucket, 1, status: 'live', group: group2)

        # new_funded_buckets
        create_list(:bucket, 2, status: 'funded', group: group1)
        create_list(:bucket, 1, status: 'funded', group: group2)
      end

      # make some new activity
      Timecop.freeze(current_time - 30.minutes) do
        # comments_on_buckets_user_participated_in
        create_list(:comment, 1, bucket: group1_bucket_that_user_has_participated_in)
        create_list(:comment, 2, bucket: group2_bucket_that_user_has_participated_in)

        # comments_on_users_buckets
        create_list(:comment, 1, bucket: group1_bucket_that_user_has_authored)
        create_list(:comment, 2, bucket: group2_bucket_that_user_has_authored)

        # contributions_to_users_buckets
        create_list(:contribution, 1, bucket: group1_bucket_that_user_has_authored)
        create_list(:contribution, 2, bucket: group2_bucket_that_user_has_authored)

        # contributions_to_buckets_user_participated_in
        create_list(:contribution, 1, bucket: group1_bucket_that_user_has_participated_in)
        create_list(:contribution, 2, bucket: group2_bucket_that_user_has_participated_in)

        # users_buckets_fully_funded
        other_group1_bucket_that_user_has_authored.update(status: 'funded')
        group2_bucket_that_user_has_authored.update(status: 'funded')

        # new_draft_buckets
        create_list(:bucket, 1, status: 'draft', group: group1)
        create_list(:bucket, 2, status: 'draft', group: group2)

        # new_live_buckets
        create_list(:bucket, 1, status: 'live', group: group1)
        create_list(:bucket, 2, status: 'live', group: group2)

        # new_funded_buckets
        create_list(:bucket, 1, status: 'funded', group: group1)
        create_list(:bucket, 2, status: 'funded', group: group2)
      end
    end

    context "user subscribed to all recent_activity" do
      it "returns all recent_activity as a hash" do
        recent_activity = RecentActivityService.new(user: user)
        group1_recent_activity = recent_activity.for_group(group1)
        group2_recent_activity = recent_activity.for_group(group2)

        # comments_on_buckets_user_participated_in
        expect(group1_recent_activity[:comments_on_buckets_user_participated_in].length).to eq(1)
        expect(group2_recent_activity[:comments_on_buckets_user_participated_in].length).to eq(2)

        # comments_on_users_buckets
        expect(group1_recent_activity[:comments_on_users_buckets].length).to eq(1)
        expect(group2_recent_activity[:comments_on_users_buckets].length).to eq(2)

        # contributions_to_users_buckets
        expect(group1_recent_activity[:contributions_to_users_buckets].length).to eq(1)
        expect(group2_recent_activity[:contributions_to_users_buckets].length).to eq(2)

        # comments_on_buckets_user_participated_in
        expect(group1_recent_activity[:contributions_to_buckets_user_participated_in].length).to eq(1)
        expect(group2_recent_activity[:contributions_to_buckets_user_participated_in].length).to eq(2)

        # users_buckets_fully_funded
        expect(group1_recent_activity[:users_buckets_fully_funded]).to include(other_group1_bucket_that_user_has_authored)
        expect(group1_recent_activity[:users_buckets_fully_funded]).not_to include(group1_bucket_that_user_has_authored)
        expect(group2_recent_activity[:users_buckets_fully_funded]).to include(group2_bucket_that_user_has_authored)
        expect(group2_recent_activity[:users_buckets_fully_funded]).not_to include(other_group2_bucket_that_user_has_authored)

        # new_draft_buckets
        expect(group1_recent_activity[:new_draft_buckets].length).to eq(1)
        expect(group2_recent_activity[:new_draft_buckets].length).to eq(2)

        # new_live_buckets
        expect(group1_recent_activity[:new_live_buckets].length).to eq(1)
        expect(group2_recent_activity[:new_live_buckets].length).to eq(2)

        # other_buckets_fully_funded (excludes those authored by user)
        expect(group1_recent_activity[:other_buckets_fully_funded].length).to eq(1)
        expect(group2_recent_activity[:other_buckets_fully_funded].length).to eq(2)

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

        expect(recent_activity.for_group(group1)).to eq({
          comments_on_buckets_user_participated_in: nil,
          comments_on_users_buckets: nil,
          contributions_to_users_buckets: nil,
          contributions_to_buckets_user_participated_in: nil,
          users_buckets_fully_funded: nil,
          new_draft_buckets: nil,
          new_live_buckets: nil,
          other_buckets_fully_funded: nil
        })

        expect(recent_activity.for_group(group2)).to eq({
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

      expect(recent_activity.for_group(group1)).to eq({
        comments_on_buckets_user_participated_in: nil,
        comments_on_users_buckets: nil,
        contributions_to_users_buckets: nil,
        contributions_to_buckets_user_participated_in: nil,
        users_buckets_fully_funded: nil,
        new_draft_buckets: nil,
        new_live_buckets: nil,
        other_buckets_fully_funded: nil
      })

      expect(recent_activity.for_group(group2)).to eq({
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
