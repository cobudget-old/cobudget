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
    comments_on_buckets_user_authored || comments_on_buckets_user_participated_in || new_draft_buckets || new_live_buckets || new_funded_buckets || contributions_to_live_buckets_user_authored || contributions_to_live_buckets_user_participated_in || funded_buckets_user_authored || recent_activity_last_fetched_at
  end

  def last_fetched_at_formatted
    case notification_frequency
      when "hourly" then recent_activity_last_fetched_at.in_time_zone((user.utc_offset || 0) / 60).strftime("%l:%M%P").strip
      when "daily" then "yesterday"
      when "weekly" then "last week"
    end
  end

  def next_fetch_time_range
    if recent_activity_last_fetched_at && next_recent_activity_fetch_scheduled_at
      recent_activity_last_fetched_at..next_recent_activity_fetch_scheduled_at
    end
  end

  def update_next_fetch_time_range!
    update(recent_activity_last_fetched_at: next_recent_activity_fetch_scheduled_at)
  end

  private
    def update_recent_activity_last_fetched_at
      if self.notification_frequency_changed?
        time_now = DateTime.now.utc
        datetime = case self.notification_frequency
          when "hourly" then time_now.beginning_of_hour.utc
          when "daily" then (time_now.in_time_zone((self.user.utc_offset || 0) / 60).beginning_of_day + 6.hours).utc
          when "weekly" then (time_now.in_time_zone((self.user.utc_offset || 0) / 60).beginning_of_week + 6.hours).utc
        end
        self.update_columns(recent_activity_last_fetched_at: datetime)
      end
    end
end
