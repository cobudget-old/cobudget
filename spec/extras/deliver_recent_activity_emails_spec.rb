require 'rails_helper'

describe "DeliverRecentActivityEmails" do
  after do
    Timecop.return
    ActionMailer::Base.deliveries.clear
  end

  describe "#to_email_notification_subscribers!" do
    it "sends recent_personal_activity_emails to users with active memberships, who are subscribed_to_email_notifications, and who have had personal_activity in their groups in the last hour" do
      group_with_recent_activity = create(:group)
      group_with_no_recent_activity = create(:group)

      user_with_no_active_memberships = create(:user)
      create(:membership, member: user_with_no_active_memberships, group: group_with_recent_activity, archived_at: DateTime.now.utc - 4.days)

      unsubscribed_user = create(:user)
      unsubscribed_user.subscription_tracker.update(subscribed_to_email_notifications: false)
      create(:membership, member: user, group: group_with_recent_activity)

      user_with_no_recent_activity = create(:user)
      create(:membership, member: user_with_no_recent_activity, group: group_with_no_recent_activity)

      user_with_recent_activity = create(:user)
      create(:membership, member: user_with_recent_activity, group: group_with_recent_activity)

      beginning_of_hour = DateTime.now.utc.beginning_of_hour
      Timecop.freeze(beginning_of_hour + 30.minutes) do
        bucket = create(:bucket, user: user_with_recent_activity, group: group_with_recent_activity)
        comment = create(:comment, bucket: bucket)
      end

      Timecop.freeze(beginning_of_hour - 1.minute) do
        bucket = create(:bucket, user: user_with_no_recent_activity, group: group_with_no_recent_activity)
        create(:comment, bucket: bucket)
      end

      Timecop.freeze(beginning_of_hour + 60.minutes) do
        DeliverRecentActivityEmails.to_email_notification_subscribers!
        sent_emails = ActionMailer::Base.deliveries
        email_recipients = sent_emails.map { |email| email.to.first }
        expect(email_recipients).to include(user_with_recent_activity.email)
        expect(email_recipients).not_to include(user_with_no_recent_activity.email)
        expect(email_recipients).not_to include(user_with_no_active_memberships.email)
        expect(email_recipients).not_to include(unsubscribed_user.email)
      end
    end
  end

  describe "#to_daily_digest_subscribers!" do
    it "sends activity digest emails to users whose local time is 6am, with email_digest_delivery_frequency set to daily, containing recent_activity from the day previous, if it exists" do
      group_with_no_activity_in_the_past_24_hours = create(:group)
      group_with_activity_in_the_past_24_hours = create(:group)

      parisian_user_with_no_active_memberships = create(:user, utc_offset: +60)
      parisian_user_with_no_active_memberships.subscription_tracker.update(email_digest_delivery_frequency: "daily")
      create(:membership, member: parisian_user_with_no_active_memberships, group: group_with_activity_in_the_past_24_hours, archived_at: DateTime.now.utc - 5.days)

      parisian_user_subscribed_never = create(:user, utc_offset: +60)
      parisian_user_subscribed_never.subscription_tracker.update(email_digest_delivery_frequency: "never")
      group_with_activity_in_the_past_24_hours.add_member(parisian_user_subscribed_never)

      parisian_user_subscribed_weekly = create(:user, utc_offset: +60)
      parisian_user_subscribed_never.subscription_tracker.update(email_digest_delivery_frequency: "weekly")
      group_with_activity_in_the_past_24_hours.add_member(parisian_user_subscribed_weekly)

      parisian_user_with_no_activity_in_the_past_24_hours = create(:user, utc_offset: +60)
      parisian_user_with_no_activity_in_the_past_24_hours.subscription_tracker.update(email_digest_delivery_frequency: "daily")
      group_with_no_activity_in_the_past_24_hours.add_member(parisian_user_with_no_activity_in_the_past_24_hours)

      # at this particular time in the world ..
      current_utc_time = DateTime.parse("2015-11-05T05:10:00Z")

      # for the oaklanders (UTC offset +60 min) it is currently 6:10AM
      parisian_user_with_activity_in_the_past_24_hours = create(:user, utc_offset: +60)
      parisian_user_with_activity_in_the_past_24_hours.subscription_tracker.update(email_digest_delivery_frequency: "daily")
      group_with_activity_in_the_past_24_hours.add_member(parisian_user_with_activity_in_the_past_24_hours)

      # for the oaklanders (UTC offset -480 min) it is currently 9:10PM
      oakland_user_with_activity_in_the_past_24_hours = create(:user, utc_offset: -480)
      oakland_user_with_activity_in_the_past_24_hours.subscription_tracker.update(email_digest_delivery_frequency: "daily")
      group_with_activity_in_the_past_24_hours.add_member(oakland_user_with_activity_in_the_past_24_hours)

      # and for the aucklanders (UTC offset +720 min) it is currently 6:10PM
      auckland_user_with_activity_in_the_past_24_hours = create(:user, utc_offset: +720)
      auckland_user_with_activity_in_the_past_24_hours.subscription_tracker.update(email_digest_delivery_frequency: "daily")
      group_with_activity_in_the_past_24_hours.add_member(auckland_user_with_activity_in_the_past_24_hours)

      Timecop.freeze(current_utc_time.beginning_of_hour - 1.day + 30.minutes) do
        create(:bucket, group: group_with_activity_in_the_past_24_hours)
      end

      Timecop.freeze(current_utc_time.beginning_of_hour - 1.day - 1.minute) do
        create(:bucket, group: group_with_no_activity_in_the_past_24_hours)
      end

      Timecop.freeze(current_utc_time) do
        DeliverRecentActivityEmails.to_daily_digest_subscribers!
        sent_emails = ActionMailer::Base.deliveries
        email_recipients = sent_emails.map { |email| email.to.first }
        expect(email_recipients).not_to include(parisian_user_with_no_active_memberships.email)
        expect(email_recipients).not_to include(parisian_user_subscribed_never.email)
        expect(email_recipients).not_to include(parisian_user_subscribed_weekly.email)
        expect(email_recipients).not_to include(parisian_user_with_no_activity_in_the_past_24_hours.email)
        expect(email_recipients).not_to include(oakland_user_with_activity_in_the_past_24_hours.email)
        expect(email_recipients).not_to include(auckland_user_with_activity_in_the_past_24_hours.email)

        expect(email_recipients).to include(parisian_user_with_activity_in_the_past_24_hours.email)
        expect(sent_emails.first.body).to include("yesterday")
        expect(sent_emails.first.subject).to include("yesterday")
      end
    end
  end

  describe "#to_weekly_digest_subscribers!" do
    it "sends activity digest emails to users whose local time is monday 6am, with email_digest_delivery_frequency set to weekly, containing recent_activity from the week previous, if it exists" do
      group_with_no_activity_in_the_past_week = create(:group)
      group_with_activity_in_the_past_week = create(:group)

      parisian_user_with_no_active_memberships = create(:user, utc_offset: +60)
      parisian_user_with_no_active_memberships.subscription_tracker.update(email_digest_delivery_frequency: "weekly")
      create(:membership, member: parisian_user_with_no_active_memberships, group: group_with_activity_in_the_past_week, archived_at: DateTime.now.utc - 5.days)

      parisian_user_subscribed_never = create(:user, utc_offset: +60)
      parisian_user_subscribed_never.subscription_tracker.update(email_digest_delivery_frequency: "never")
      group_with_activity_in_the_past_week.add_member(parisian_user_subscribed_never)

      parisian_user_subscribed_daily = create(:user, utc_offset: +60)
      parisian_user_subscribed_daily.subscription_tracker.update(email_digest_delivery_frequency: "daily")
      group_with_activity_in_the_past_week.add_member(parisian_user_subscribed_daily)

      parisian_user_with_no_activity_in_the_past_week = create(:user, utc_offset: +60)
      parisian_user_with_no_activity_in_the_past_week.subscription_tracker.update(email_digest_delivery_frequency: "weekly")
      group_with_no_activity_in_the_past_week.add_member(parisian_user_with_no_activity_in_the_past_week)

      # at this particular time in the world ..
      current_utc_time = DateTime.parse("2015-11-02T05:10:00Z")

      # for the oaklanders (UTC offset +60 min) it is currently monday, 6:10AM
      parisian_user_with_activity_in_the_past_week = create(:user, utc_offset: +60)
      parisian_user_with_activity_in_the_past_week.subscription_tracker.update(email_digest_delivery_frequency: "weekly")
      group_with_activity_in_the_past_week.add_member(parisian_user_with_activity_in_the_past_week)

      # for the oaklanders (UTC offset -480 min) it is currently sunday, 9:10PM
      oakland_user_with_activity_in_the_past_week = create(:user, utc_offset: -480)
      oakland_user_with_activity_in_the_past_week.subscription_tracker.update(email_digest_delivery_frequency: "weekly")
      group_with_activity_in_the_past_week.add_member(oakland_user_with_activity_in_the_past_week)

      # and for the aucklanders (UTC offset +720 min) it is currently monday, 6:10PM
      auckland_user_with_activity_in_the_past_week = create(:user, utc_offset: +720)
      auckland_user_with_activity_in_the_past_week.subscription_tracker.update(email_digest_delivery_frequency: "weekly")
      group_with_activity_in_the_past_week.add_member(auckland_user_with_activity_in_the_past_week)

      Timecop.freeze(current_utc_time.beginning_of_hour - 1.week + 30.minutes) do
        create(:bucket, group: group_with_activity_in_the_past_week)
      end

      Timecop.freeze(current_utc_time.beginning_of_hour - 1.week - 1.minute) do
        create(:bucket, group: group_with_no_activity_in_the_past_week)
      end

      Timecop.freeze(current_utc_time) do
        DeliverRecentActivityEmails.to_weekly_digest_subscribers!
        sent_emails = ActionMailer::Base.deliveries
        email_recipients = sent_emails.map { |email| email.to.first }
        expect(email_recipients).not_to include(parisian_user_with_no_active_memberships.email)
        expect(email_recipients).not_to include(parisian_user_subscribed_never.email)
        expect(email_recipients).not_to include(parisian_user_subscribed_daily.email)
        expect(email_recipients).not_to include(parisian_user_with_no_activity_in_the_past_week.email)
        expect(email_recipients).not_to include(oakland_user_with_activity_in_the_past_week.email)
        expect(email_recipients).not_to include(auckland_user_with_activity_in_the_past_week.email)

        expect(email_recipients).to include(parisian_user_with_activity_in_the_past_week.email)
        expect(sent_emails.first.body).to include("last week")
        expect(sent_emails.first.subject).to include("last week")
      end
    end
  end
end
