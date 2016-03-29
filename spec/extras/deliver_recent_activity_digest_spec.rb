require 'rails_helper'

describe "DeliverRecentActivityDigest" do
  after { Timecop.return }

  describe "#run!" do
    before { allow(UserService).to receive(:send_recent_activity_email) }

    context "user has no active memberships" do
      before { create(:user) }

      it "does nothing" do
        expect(UserService).not_to receive(:send_recent_activity_email)
        DeliverRecentActivityDigest.run!
      end
    end

    context "user has at least one active membership" do
      before { make_user_group_member }

      context "current_time is before user's next scheduled fetch" do
        it "does nothing" do
          time = (user.subscription_tracker.next_recent_activity_fetch_scheduled_at - 1.minute).utc
          Timecop.freeze(time) do
            expect(UserService).not_to receive(:send_recent_activity_email)
            DeliverRecentActivityDigest.run!
          end
        end
      end

      context "current_time is after user's next scheduled fetch" do
        it "calls fetches activity for user and updates their subscription_tracker's next fetch_time_range" do
          old_next_recent_activity_scheduled_at = user.subscription_tracker.next_recent_activity_fetch_scheduled_at

          time = (old_next_recent_activity_scheduled_at + 1.minute).utc
          Timecop.freeze(time) do
            expect(UserService).to receive(:send_recent_activity_email)
            DeliverRecentActivityDigest.run!
            expect(user.subscription_tracker.reload.recent_activity_last_fetched_at).to eq(old_next_recent_activity_scheduled_at)
          end
        end
      end
    end
  end
end
