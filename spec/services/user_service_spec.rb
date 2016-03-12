require 'rails_helper'

describe "UserService" do
  describe "recent_activity_for(user:)" do
    let(:current_time) { DateTime.now.utc }
    let(:user) { create(:user) }
    # notification_frequency set to 'hourly' by default
    let(:subscription_tracker) { user.subscription_tracker }

    after { Timecop.return }
    before do
      subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)

      # # make some recent activity
      # Timecop.freeze(current_time - 30.minutes) do
      # end

      # # make some old activity
      # Timecop.freeze(current_time - 70.minutes) do
      # end
    end
  end

  describe "#comments_on_buckets_user_participated_in" do
    context "user subscribed" do
      it "returns all recent comments on buckets that user has participated in" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#comments_on_user_buckets" do
    context "user subscribed" do
      it "returns all recent comments on buckets that user has authored" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#contributions_to_users_buckets" do
    context "user subscribed" do
      it "returns all recent contributions to buckets that user has authored" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#contributions_to_buckets_user_participated_in" do
    context "user subscribed" do
      it "returns all recent contributions to buckets that user has participated in" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#users_buckets_fully_funded" do
    context "user subscribed" do
      it "returns all buckets the user has authored that have been recently funded" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#new_draft_buckets" do
    context "user subscribed" do
      it "returns all recently created bucket ideas in user's groups" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#new_live_buckets" do
    context "user subscribed" do
      it "returns all buckets in user's groups that have recently gone live" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#new_funded_buckets" do
    context "user subscribed" do
      it "returns all buckets in user's groups that have recently been fully funded" do
      end
    end

    context "user not subscribed" do
      it "returns nil" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#collated_activity_for_group(group)" do
    context "recent activity exists" do
      it "returns array containing group and activity hash" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end

  describe "#fetch_recent_activity_for(user:)" do
    context "recent_activity exists" do
      it "returns a hash where keys are the user's active groups, and values are activity hashes" do
      end
    end

    context "no recent activity" do
      it "returns nil" do
      end
    end
  end
end
