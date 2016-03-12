class SubscriptionTracker < ActiveRecord::Base
  belongs_to :user
  after_update :update_recent_activity_last_fetched_at

  def next_recent_activity_fetch_scheduled_at
    interval = case notification_frequency
      when "hourly" then 1.hour
      when "daily" then 1.day
      when "weekly" then 1.week
    end
    recent_activity_last_fetched_at + interval if interval
  end

  def ready_to_fetch?(current_time: )
    notification_frequency != "never" && current_time >= next_recent_activity_fetch_scheduled_at
  end

  private
    def update_recent_activity_last_fetched_at
      if self.notification_frequency_changed?
        time_now = DateTime.now.utc
        datetime = case self.notification_frequency
          when "hourly" then time_now.beginning_of_hour
          when "daily" then (time_now.in_time_zone(self.user.utc_offset / 60).beginning_of_day + 6.hours)
          when "weekly" then (time_now.in_time_zone(self.user.utc_offset / 60).beginning_of_week + 6.hours)
        end
        self.update_columns(recent_activity_last_fetched_at: datetime.utc)
      end
    end
end
