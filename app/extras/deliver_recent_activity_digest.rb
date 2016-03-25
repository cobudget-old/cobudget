class DeliverRecentActivityDigest
  def self.run!
    current_time = DateTime.now.utc
    User.with_active_memberships.each do |user|
      if user.subscription_tracker.ready_to_fetch?(current_time: current_time)
        UserService.send_recent_activity_email(user: user)
      end
    end
  end
end
