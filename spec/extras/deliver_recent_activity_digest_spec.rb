require 'rails_helper'

describe "DeliverRecentActivityDigest" do
  let!(:current_time) { DateTime.now.utc }
  let!(:user) { create(:user) }
  let!(:subscription_tracker) { user.subscription_tracker }

  before do
    subscription_tracker.update(notification_frequency: "hourly")
    subscription_tracker.update(recent_activity_last_fetched_at: current_time - 1.hour)
  end

  after do
    Timecop.return
    ActionMailer::Base.deliveries.clear
  end

  describe "#run!" do
    context "user has no active memberships" do
      it "does not send a recent activity notification email to the user" do
        Timecop.freeze(current_time + 1.minute) do
          DeliverRecentActivityDigest.run!
          expect(ActionMailer::Base.deliveries).to be_empty
        end
      end

      it "does not schedule the next recent activity fetch" do
        Timecop.freeze(current_time + 1.minute) do
          DeliverRecentActivityDigest.run!
          expect(subscription_tracker.reload.recent_activity_last_fetched_at).to be_within(1).of(current_time - 1.hour)
        end
      end
    end

    context "user has at least one active membership" do
      let!(:group) { create(:group) }
      let!(:membership) { create(:membership, member: user, group: group) }

      context "current_time is before user's next scheduled fetch" do
        it "does not send a recent activity notification email to the user" do
          Timecop.freeze(current_time - 1.minute) do
            DeliverRecentActivityDigest.run!
            expect(ActionMailer::Base.deliveries).to be_empty
          end
        end

        it "does not schedule the next recent activity fetch" do
          Timecop.freeze(current_time - 1.minute) do
            DeliverRecentActivityDigest.run!
            expect(subscription_tracker.reload.recent_activity_last_fetched_at).to be_within(1).of(current_time - 1.hour)
          end
        end
      end

      context "current_time is after user's next scheduled fetch" do
        context "recent activity exists" do
          before do
            Timecop.freeze(current_time - 1.minute) do
              create(:bucket, group: group, status: "draft", name: "le bucket", user: user)
            end
          end

          it "sends a recent activity notification email to the user" do
            Timecop.freeze(current_time + 1.minute) do
              DeliverRecentActivityDigest.run!
              expect(ActionMailer::Base.deliveries.length).to eq(1)

              sent_email = ActionMailer::Base.deliveries.first

              expect(sent_email.to).to include(user.email)
              expect(sent_email.subject).to include("My recent activity on Cobudget")
              expect(sent_email.body).to include("le bucket")
            end
          end

          it "updates user's subscription_tracker's recent_activity_last_fetched_at timestamp" do
            Timecop.freeze(current_time + 1.minute) do
              DeliverRecentActivityDigest.run!
              expect(subscription_tracker.reload.recent_activity_last_fetched_at).to be_within(1).of(current_time)
            end
          end
        end

        context "recent activity does not exist" do
          it "does not send a recent activity notification email to the user" do
            Timecop.freeze(current_time + 1.minute) do
              DeliverRecentActivityDigest.run!
              expect(ActionMailer::Base.deliveries).to be_empty
            end
          end

          it "updates user's subscription_tracker's recent_activity_last_fetched_at timestamp" do
            Timecop.freeze(current_time + 1.minute) do
              DeliverRecentActivityDigest.run!
              expect(subscription_tracker.reload.recent_activity_last_fetched_at).to be_within(1).of(current_time)
            end
          end
        end
      end
    end
  end
end
