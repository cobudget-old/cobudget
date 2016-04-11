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
end
