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

  describe "#next_recent_activity_fetch_scheduled_at" do
    let(:subscription_tracker) { parisian_user.subscription_tracker }
    let(:six_am_today) { DateTime.now.utc.beginning_of_day + 6.hours }

    def subscription_tracker_with_last_fetch_today_at_six_am(notification_frequency: )
      subscription_tracker.update(notification_frequency: notification_frequency)
      subscription_tracker.update(recent_activity_last_fetched_at: six_am_today)
      subscription_tracker
    end

    context "if notification_frequency is 'never'" do
      it "returns nil" do
        tracker = subscription_tracker_with_last_fetch_today_at_six_am(notification_frequency: "never")
        expect(tracker.next_recent_activity_fetch_scheduled_at).to be_nil
      end
    end

    context "if notification_frequency is 'hourly'" do
      it "returns datetime 1 hour after last fetch" do
        tracker = subscription_tracker_with_last_fetch_today_at_six_am(notification_frequency: "hourly")
        expect(tracker.next_recent_activity_fetch_scheduled_at).to eq(six_am_today + 1.hour)
      end
    end

    context "if notification_frequency is 'daily'" do
      it "returns datetime 1 day after last fetch" do
        tracker = subscription_tracker_with_last_fetch_today_at_six_am(notification_frequency: "daily")
        expect(tracker.next_recent_activity_fetch_scheduled_at).to eq(six_am_today + 1.day)
      end
    end

    context "if notification_frequency is 'weekly'" do
      it "returns datetime 1 week after last fetch" do
        tracker = subscription_tracker_with_last_fetch_today_at_six_am(notification_frequency: "weekly")
        expect(tracker.next_recent_activity_fetch_scheduled_at).to eq(six_am_today + 1.week)
      end
    end
  end

  describe "#last_fetched_at_formatted" do
    let(:subscription_tracker) { parisian_user.subscription_tracker }

    context "notification_frequency is 'hourly'" do
      it "returns local time formatted as %l:%M%P" do
        subscription_tracker.update(recent_activity_last_fetched_at: current_utc_time)
        expect(subscription_tracker.last_fetched_at_formatted).to eq("6:10am")
      end
    end

    context "notification_frequency is 'daily'" do
      it "returns 'yesterday'" do
        subscription_tracker.update(notification_frequency: "daily")
        expect(subscription_tracker.last_fetched_at_formatted).to eq("yesterday")
      end
    end

    context "notification_frequency is 'weekly'" do
      it "returns 'weekly'" do
        subscription_tracker.update(notification_frequency: "weekly")
        expect(subscription_tracker.last_fetched_at_formatted).to eq("last week")
      end
    end

    context "notification_frequency is 'never'" do
      it "returns 'never'" do
        subscription_tracker.update(notification_frequency: "never")
        expect(subscription_tracker.last_fetched_at_formatted).to be_nil
      end
    end
  end
end
