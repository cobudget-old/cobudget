class UserService
  def self.send_recent_activity_email(user:)
    recent_activity = RecentActivityService.new(user: user)
    if recent_activity.is_present?
      UserMailer.recent_activity(user: user, recent_activity: recent_activity).deliver_later
    end
  end

  def self.merge_users(user_to_kill:, user_to_keep:)
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
