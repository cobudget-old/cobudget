class DeliverRecentActivityEmails
  def self.to_email_notification_subscribers!
    current_hour_utc = DateTime.now.utc.beginning_of_hour
    subscribers = User.with_active_memberships.joins(:subscription_tracker).where(subscription_trackers: { subscribed_to_email_notifications: true} )
    subscribers.each do |subscriber|
      UserMailer.recent_personal_activity_email(user: subscriber, time_range: (current_hour_utc - 1.hour)..current_hour_utc).deliver_later
    end
  end

  def self.to_daily_digest_subscribers!
  end

  def self.to_weekly_digest_subscribers!
  end
end

=begin
every hour, we need to go through every user:
  if (1) user is `subscribed_to_email_notifications` and (2) that user has personal_recent_activity between the beginning of last hour and the beginning of this hour
    collect that `personal_recent_activity`, and send an email to the user, asynchronously
  if (1) user's `email_digest_delivery_frequency` is set to 'daily' and (2) the beginning of this UTC hour is 6AM for their local time, and (3) recent activit yexist
    collect `all_recent_activity` between 6AM yesterday and 6AM today, and send it via email
  if (1) user's `email_digest_delivery_frequency` is set to 'weekly' and (2) the beginning of this UTC hour is 6AM monday for ther local time
    collect `all_recent_activity` between 6AM last monday and 6AM this monday, and send it via email
=end
