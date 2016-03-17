class UserService
  def self.send_recent_activity_emails(user:)
    recent_activity = RecentActivityService.new(user: user)
  end
end
