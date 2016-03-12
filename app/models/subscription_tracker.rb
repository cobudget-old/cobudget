class SubscriptionTracker < ActiveRecord::Base
  belongs_to :user
  after_update :update_recent_activity_last_fetched_at

  private
    def update_recent_activity_last_fetched_at
      if self.notification_frequency_changed?
        time_now = DateTime.now.utc
        datetime = case self.notification_frequency
          when "never" then nil
          when "hourly" then time_now.beginning_of_hour
          when "daily" then (time_now.in_time_zone(self.user.utc_offset / 60).beginning_of_day + 6.hours).utc
          when "weekly" then (time_now.in_time_zone(self.user.utc_offset / 60).beginning_of_week + 6.hours).utc
        end
        self.update_columns(recent_activity_last_fetched_at: datetime)
      end
    end
end
