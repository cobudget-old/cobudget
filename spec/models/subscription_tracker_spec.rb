require 'rails_helper'

RSpec.describe SubscriptionTracker, type: :model do
  # at this particular time in the world ..
  let!(:current_utc_time) { DateTime.parse("2015-11-05T05:10:00Z") }
  # for the parisians (UTC offset +60 min) it is currently 6:10AM
  let!(:parisian_user) { create(:user, utc_offset: +60) }
  # for the oaklanders (UTC offset -480 min) it is currently 9:10PM
  let!(:oakland_user) { create(:user, utc_offset: -480) }
  # and for the aucklanders (UTC offset +720 min) it is currently 6:10PM
  let!(:auckland_user) { create(:user, utc_offset: +720) }

  after { Timecop.return }

  def six_am_today_for_user_in_utc(user)
    (DateTime.now.utc.in_time_zone(user.utc_offset / 60).beginning_of_day + 6.hours).utc
  end

  def six_am_beginning_of_week_for_user_in_utc(user)
    (DateTime.now.utc.in_time_zone(user.utc_offset / 60).beginning_of_week + 6.hours).utc
  end

  def update_user_subscriptions(notification_frequency: )
    User.find_each do |user|
      user.subscription_tracker.update(notification_frequency: notification_frequency)
    end
  end

  context "notification_frequency updated" do
    context "to never" do
      it "sets recent_activity_last_fetched_at to nil" do
        Timecop.freeze(current_utc_time) do
          update_user_subscriptions(notification_frequency: "never")
          expect(parisian_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(nil)
          expect(oakland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(nil)
          expect(auckland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(nil)
        end
      end
    end

    context "to hourly" do
      it "sets recent_activity_last_fetched_at to the beginning of this hour" do
        Timecop.freeze(current_utc_time) do
          update_user_subscriptions(notification_frequency: "never")
          update_user_subscriptions(notification_frequency: "hourly")
          beginning_of_the_hour = DateTime.parse("2015-11-05T05:00:00Z")
          expect(parisian_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(beginning_of_the_hour)
          expect(oakland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(beginning_of_the_hour)
          expect(auckland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(beginning_of_the_hour)
        end
      end
    end

    context "to daily" do
      it "sets recent_activity_last_fetched_at to 6am today (user's local time)" do
        Timecop.freeze(current_utc_time) do
          update_user_subscriptions(notification_frequency: "daily")
          expect(parisian_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(six_am_today_for_user_in_utc(parisian_user))
          expect(oakland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(six_am_today_for_user_in_utc(oakland_user))
          expect(auckland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(six_am_today_for_user_in_utc(auckland_user))
        end
      end
    end

    context "to weekly" do
      it "sets recent_activity_last_fetched_at to 6am of the beginning of the week (monday) (user's local time)" do
        Timecop.freeze(current_utc_time) do
          update_user_subscriptions(notification_frequency: "weekly")
          expect(parisian_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(six_am_beginning_of_week_for_user_in_utc(parisian_user))
          expect(oakland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(six_am_beginning_of_week_for_user_in_utc(oakland_user))
          expect(auckland_user.reload.subscription_tracker.recent_activity_last_fetched_at).to eq(six_am_beginning_of_week_for_user_in_utc(auckland_user))
        end
      end
    end
  end
end
