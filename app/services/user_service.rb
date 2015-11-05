class UserService
  def self.fetch_recent_activity_for(user:)
    user_utc_offset_in_hours = user.utc_offset / 60
    user_6am_today_in_utc = (DateTime.now.in_time_zone(user_utc_offset_in_hours).beginning_of_day + 6.hours).utc 
    user_6am_yesterday_in_utc = user_6am_today_in_utc - 1.day

    user.groups.map do |group|
      draft_buckets = Bucket.where(group: group, status: 'draft', created_at: (user_6am_yesterday_in_utc ... user_6am_today_in_utc ))
      live_buckets = Bucket.where(group: group, status: 'live', live_at: (user_6am_yesterday_in_utc ... user_6am_today_in_utc ))
      funded_buckets = Bucket.where(group: group, status: 'funded', funded_at: (user_6am_yesterday_in_utc ... user_6am_today_in_utc ))
      {
        group: group,
        draft_buckets: draft_buckets,
        live_buckets: live_buckets,
        funded_buckets: funded_buckets
      }
    end
  end
end