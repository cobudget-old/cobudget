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

  def subscribed_to_any_activity?
    comment_on_your_bucket || comment_on_bucket_you_participated_in || bucket_idea_created || bucket_started_funding || bucket_fully_funded || funding_for_your_bucket || funding_for_a_bucket_you_participated_in || your_bucket_fully_funded || recent_activity_last_fetched_at
  end

  private
    def update_recent_activity_last_fetched_at
      if self.notification_frequency_changed?
        time_now = DateTime.now.utc
        datetime = case self.notification_frequency
          when "hourly" then time_now.beginning_of_hour.utc
          when "daily" then (time_now.in_time_zone(self.user.utc_offset / 60).beginning_of_day + 6.hours).utc
          when "weekly" then (time_now.in_time_zone(self.user.utc_offset / 60).beginning_of_week + 6.hours).utc
        end
        self.update_columns(recent_activity_last_fetched_at: datetime)
      end
    end
end
