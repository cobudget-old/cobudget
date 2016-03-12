require 'rails_helper'

describe "DeliverRecentActivityDigest" do
  after { Timecop.return }

  describe "#run!" do
    before do
      allow(UserService).to receive(:fetch_recent_activity_for)
    end

    context "user has no active memberships" do
      before do
        create(:user)
      end

      it "does nothing" do
        expect(UserService).not_to receive(:fetch_recent_activity_for)
        DeliverRecentActivityDigest.run!
      end
    end

    context "user has at least one active membership" do
      before do
        make_user_group_member
      end

      context "current_time is before user's next scheduled fetch" do
        it "does nothing" do
          time = (user.subscription_tracker.next_recent_activity_fetch_scheduled_at - 1.minute).utc
          Timecop.freeze(time) do
            expect(UserService).not_to receive(:fetch_recent_activity_for)
            DeliverRecentActivityDigest.run!
          end
        end
      end

      context "current_time is after user's next scheduled fetch" do
        it "calls fetches activity for user" do
          time = (user.subscription_tracker.next_recent_activity_fetch_scheduled_at + 1.minute).utc
          Timecop.freeze(time) do
            expect(UserService).to receive(:fetch_recent_activity_for)
            DeliverRecentActivityDigest.run!
          end
        end
      end
    end
  end
end
