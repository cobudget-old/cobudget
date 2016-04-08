class DeliverRecentActivityDigest
  def self.run!
    current_time = DateTime.now.utc
    User.with_active_memberships.each do |user|
      if user.subscription_tracker.ready_to_fetch?(current_time: current_time)
        UserMailer.recent_activity_email(user: user).deliver_later
        user.subscription_tracker.update_next_fetch_time_range!
      end
    end
  end
end
