class UserService
  def self.fetch_recent_activity_for(user:)
    return nil unless user.utc_offset
    user_utc_offset_in_hours = user.utc_offset / 60
    user_6am_today_in_utc = (DateTime.now.in_time_zone(user_utc_offset_in_hours).beginning_of_day + 6.hours).utc
    user_6am_yesterday_in_utc = user_6am_today_in_utc - 1.day

    recent_activity = user.memberships.active.map do |membership|
      group = membership.group
      draft_buckets = Bucket.where(group: group, status: 'draft', created_at: (user_6am_yesterday_in_utc ... user_6am_today_in_utc ))
      live_buckets = Bucket.where(group: group, status: 'live', live_at: (user_6am_yesterday_in_utc ... user_6am_today_in_utc ))
      funded_buckets = Bucket.where(group: group, status: 'funded', funded_at: (user_6am_yesterday_in_utc ... user_6am_today_in_utc ))
      {
        group: group,
        membership: membership,
        draft_buckets: draft_buckets,
        live_buckets: live_buckets,
        funded_buckets: funded_buckets
      }
    end

    recent_activity.select! { |a| a[:draft_buckets].any? || a[:live_buckets].any? || a[:funded_buckets].any? }

    recent_activity if recent_activity.any?
  end

  def self.merge_users(user_to_kill:, user_to_keep:)
    if user_to_kill == user_to_keep 
      puts "nope" unless Rails.env.test?
      return
    end

    user_to_kill.memberships.each do |membership|
      memberships = Membership.where(group: membership.group, member: [user_to_keep, user_to_kill])

      if existing_membership = memberships.find_by(member: user_to_keep)
        existing_membership.update(is_admin: true) if memberships.where(is_admin: true).any?
        existing_membership.reactivate! if memberships.active.any?
        membership.destroy
      else
        membership.update(member: user_to_keep)
      end
    end

    %i( allocations contributions buckets comments ).each do |key|
      user_to_kill.send(key).update_all(user_id: user_to_keep.id)
    end

    user_to_kill.reload.destroy
  end
end
