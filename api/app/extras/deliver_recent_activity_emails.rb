class DeliverRecentActivityEmails
  def self.to_email_notification_subscribers!
    current_hour_utc = DateTime.now.utc.beginning_of_hour
    subscribers = User.with_active_memberships.joins(:subscription_tracker).where(subscription_trackers: { subscribed_to_email_notifications: true} )
    subscribers.each do |subscriber|
      UserMailer.recent_personal_activity_email(user: subscriber).deliver_later
    end
  end

  def self.to_daily_digest_subscribers!
    current_hour_utc = DateTime.now.utc.beginning_of_hour
    subscribers = User.with_active_memberships.joins(:subscription_tracker).where(subscription_trackers: { email_digest_delivery_frequency: "daily" } )
    subscribers.each do |subscriber|
      if current_hour_utc.in_time_zone((subscriber.utc_offset || 0) / 60).hour == 6
        UserMailer.recent_activity_digest_email(user: subscriber).deliver_later
      end
    end
  end

  def self.to_weekly_digest_subscribers!
    current_hour_utc = DateTime.now.utc.beginning_of_hour
    subscribers = User.with_active_memberships.joins(:subscription_tracker).where(subscription_trackers: { email_digest_delivery_frequency: "weekly" } )
    subscribers.each do |subscriber|
      current_hour_local = current_hour_utc.in_time_zone((subscriber.utc_offset || 0) / 60)
      if current_hour_local.hour == 6 && current_hour_local.wday == 1
        UserMailer.recent_activity_digest_email(user: subscriber).deliver_later
      end
    end
  end
end
