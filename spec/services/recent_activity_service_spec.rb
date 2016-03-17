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

  describe "recent_activity_for(user:)" do
    before do
      create(:allocation, user: user, group: group1, amount: 20000)
      create(:allocation, user: user, group: group2, amount: 20000)
      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)
      create(:comment, user: user, bucket: group1_bucket_that_user_has_participated_in)
      create(:contribution, user: user, bucket: group2_bucket_that_user_has_participated_in)
    end

    after { Timecop.return }

    context "user is subscribed to all activity" do

      describe "#comments_on_buckets_user_participated_in(group:)" do
        it "returns recent comments on buckets user has participated in, in specifed group" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:comment, 2, bucket: group1_bucket_that_user_has_participated_in)
            create_list(:comment, 1, bucket: group2_bucket_that_user_has_participated_in)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:comment, 1, bucket: group1_bucket_that_user_has_participated_in)
            create_list(:comment, 2, bucket: group2_bucket_that_user_has_participated_in)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.comments_on_buckets_user_participated_in(group: group1).length).to eq(1)
          expect(recent_activity.comments_on_buckets_user_participated_in(group: group2).length).to eq(2)
        end
      end

      describe "#comments_on_users_buckets(group:)" do
        it "returns recent comments on buckets user has authored, in specifed group" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:comment, 2, bucket: group1_bucket_that_user_has_authored)
            create_list(:comment, 1, bucket: group2_bucket_that_user_has_authored)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:comment, 1, bucket: group1_bucket_that_user_has_authored)
            create_list(:comment, 2, bucket: group2_bucket_that_user_has_authored)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.comments_on_users_buckets(group: group1).length).to eq(1)
          expect(recent_activity.comments_on_users_buckets(group: group2).length).to eq(2)
        end
      end

      describe "#contributions_to_users_buckets(group:)" do
        it "returns recent contributions on buckets user has authored, in specified group" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:contribution, 2, bucket: group1_bucket_that_user_has_authored)
            create_list(:contribution, 1, bucket: group2_bucket_that_user_has_authored)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:contribution, 1, bucket: group1_bucket_that_user_has_authored)
            create_list(:contribution, 2, bucket: group2_bucket_that_user_has_authored)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.contributions_to_users_buckets(group: group1).length).to eq(1)
          expect(recent_activity.contributions_to_users_buckets(group: group2).length).to eq(2)
        end
      end

      describe "#contributions_to_buckets_user_participated_in(group:)" do
        it "returns recent contributions on buckets user has participated in, in specifed group" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:contribution, 2, bucket: group1_bucket_that_user_has_participated_in)
            create_list(:contribution, 1, bucket: group2_bucket_that_user_has_participated_in)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:contribution, 1, bucket: group1_bucket_that_user_has_participated_in)
            create_list(:contribution, 2, bucket: group2_bucket_that_user_has_participated_in)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.contributions_to_buckets_user_participated_in(group: group1).length).to eq(1)
          expect(recent_activity.contributions_to_buckets_user_participated_in(group: group2).length).to eq(2)
        end
      end

      describe "#users_buckets_fully_funded(group:)" do
        it "returns all recent buckets that have been fully funded, in specified group" do
          Timecop.freeze(current_time - 70.minutes) do
            group1_bucket_that_user_has_authored.update(status: 'funded')
            other_group2_bucket_that_user_has_authored.update(status: 'funded')
          end

          Timecop.freeze(current_time - 30.minutes) do
            # users_buckets_fully_funded
            other_group1_bucket_that_user_has_authored.update(status: 'funded')
            group2_bucket_that_user_has_authored.update(status: 'funded')
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.users_buckets_fully_funded(group: group1)).to include(other_group1_bucket_that_user_has_authored)
          expect(recent_activity.users_buckets_fully_funded(group: group1)).not_to include(group1_bucket_that_user_has_authored)
          expect(recent_activity.users_buckets_fully_funded(group: group2)).to include(group2_bucket_that_user_has_authored)
          expect(recent_activity.users_buckets_fully_funded(group: group2)).not_to include(other_group2_bucket_that_user_has_authored)
        end
      end

      describe "#new_draft_buckets(group:)" do
        it "returns all recently created draft buckets, in specified group" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:bucket, 2, status: 'draft', group: group1)
            create_list(:bucket, 1, status: 'draft', group: group2)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:bucket, 1, status: 'draft', group: group1)
            create_list(:bucket, 2, status: 'draft', group: group2)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.new_draft_buckets(group: group1).length).to eq(1)
          expect(recent_activity.new_draft_buckets(group: group2).length).to eq(2)
        end
      end

      describe "#new_live_buckets(group:)" do
        it "returns all buckets that have recently gone live, in specified group" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:bucket, 2, status: 'live', group: group1)
            create_list(:bucket, 1, status: 'live', group: group2)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:bucket, 1, status: 'live', group: group1)
            create_list(:bucket, 2, status: 'live', group: group2)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.new_live_buckets(group: group1).length).to eq(1)
          expect(recent_activity.new_live_buckets(group: group2).length).to eq(2)
        end
      end

      describe "#other_buckets_fully_funded(group:)" do
        it "returns all buckets that have recently been funded, in specified group -- but excluding those authored by user" do
          Timecop.freeze(current_time - 70.minutes) do
            create_list(:bucket, 2, status: 'funded', group: group1)
            create_list(:bucket, 1, status: 'funded', group: group2)
          end

          Timecop.freeze(current_time - 30.minutes) do
            create_list(:bucket, 1, status: 'funded', group: group1)
            create_list(:bucket, 2, status: 'funded', group: group2)
            create_list(:bucket, 1, status: 'funded', group: group1, user: user)
            create_list(:bucket, 1, status: 'funded', group: group2, user: user)
          end

          recent_activity = RecentActivityService.new(user: user)

          expect(recent_activity.other_buckets_fully_funded(group: group1).length).to eq(1)
          expect(recent_activity.other_buckets_fully_funded(group: group2).length).to eq(2)
        end
      end
    end

    context "recent activity exists, but user not subscribed to any of it" do
      it "returns nil instead" do
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

        # comments_on_buckets_user_participated_in
        expect(recent_activity.comments_on_buckets_user_participated_in(group: group1)).to be_nil
        expect(recent_activity.comments_on_buckets_user_participated_in(group: group2)).to be_nil

        # comments_on_users_buckets
        expect(recent_activity.comments_on_users_buckets(group: group1)).to be_nil
        expect(recent_activity.comments_on_users_buckets(group: group2)).to be_nil

        # contributions_to_users_buckets
        expect(recent_activity.contributions_to_users_buckets(group: group1)).to be_nil
        expect(recent_activity.contributions_to_users_buckets(group: group2)).to be_nil

        # comments_on_buckets_user_participated_in
        expect(recent_activity.contributions_to_buckets_user_participated_in(group: group1)).to be_nil
        expect(recent_activity.contributions_to_buckets_user_participated_in(group: group2)).to be_nil

        # users_buckets_fully_funded
        expect(recent_activity.users_buckets_fully_funded(group: group1)).to be_nil
        expect(recent_activity.users_buckets_fully_funded(group: group1)).to be_nil
        expect(recent_activity.users_buckets_fully_funded(group: group2)).to be_nil
        expect(recent_activity.users_buckets_fully_funded(group: group2)).to be_nil

        # new_draft_buckets
        expect(recent_activity.new_draft_buckets(group: group1)).to be_nil
        expect(recent_activity.new_draft_buckets(group: group2)).to be_nil

        # new_live_buckets
        expect(recent_activity.new_live_buckets(group: group1)).to be_nil
        expect(recent_activity.new_live_buckets(group: group2)).to be_nil

        # other_buckets_fully_funded (excludes those authored by user)
        expect(recent_activity.other_buckets_fully_funded(group: group1)).to be_nil
        expect(recent_activity.other_buckets_fully_funded(group: group2)).to be_nil
      end
    end

    context "user subscribed to recent activity, but none exists" do
      it "returns nil instead" do
        recent_activity = RecentActivityService.new(user: user)

        # comments_on_buckets_user_participated_in
        expect(recent_activity.comments_on_buckets_user_participated_in(group: group1)).to be_nil
        expect(recent_activity.comments_on_buckets_user_participated_in(group: group2)).to be_nil

        # comments_on_users_buckets
        expect(recent_activity.comments_on_users_buckets(group: group1)).to be_nil
        expect(recent_activity.comments_on_users_buckets(group: group2)).to be_nil

        # contributions_to_users_buckets
        expect(recent_activity.contributions_to_users_buckets(group: group1)).to be_nil
        expect(recent_activity.contributions_to_users_buckets(group: group2)).to be_nil

        # comments_on_buckets_user_participated_in
        expect(recent_activity.contributions_to_buckets_user_participated_in(group: group1)).to be_nil
        expect(recent_activity.contributions_to_buckets_user_participated_in(group: group2)).to be_nil

        # users_buckets_fully_funded
        expect(recent_activity.users_buckets_fully_funded(group: group1)).to be_nil
        expect(recent_activity.users_buckets_fully_funded(group: group1)).to be_nil
        expect(recent_activity.users_buckets_fully_funded(group: group2)).to be_nil
        expect(recent_activity.users_buckets_fully_funded(group: group2)).to be_nil

        # new_draft_buckets
        expect(recent_activity.new_draft_buckets(group: group1)).to be_nil
        expect(recent_activity.new_draft_buckets(group: group2)).to be_nil

        # new_live_buckets
        expect(recent_activity.new_live_buckets(group: group1)).to be_nil
        expect(recent_activity.new_live_buckets(group: group2)).to be_nil

        # other_buckets_fully_funded (excludes those authored by user)
        expect(recent_activity.other_buckets_fully_funded(group: group1)).to be_nil
        expect(recent_activity.other_buckets_fully_funded(group: group2)).to be_nil
      end
    end
  end
end
