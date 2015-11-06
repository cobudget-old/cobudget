class DeliverDailyEmailDigest
  # TODO LATER: scope this to users who have actually subscribed to the digest
  # until the email settings feature is complete, email digest will be default
  def self.to_subscribers!
    unique_utc_offsets = User.pluck('DISTINCT utc_offset').select do |utc_offset|
      (Time.now.utc + utc_offset.minutes).hour == 6 if utc_offset
    end

    User.where(utc_offset: unique_utc_offsets).find_each do |user|
      if recent_activity = UserService.fetch_recent_activity_for(user: user)
        UserMailer.daily_email_digest(user: user, recent_activity: recent_activity).deliver_later
      end
    end
  end
end