class Announcement < ActiveRecord::Base

  scope :tracked, -> (user) {
     where("expired_at is NULL or expired_at > ?", Time.now).
     order(created_at: :desc).
     select("announcements.*, (SELECT last_seen from announcement_trackers where user_id = #{user.id})")
  }

  def seen
    has_attribute?(:last_seen) ? (last_seen ? last_seen >= created_at : false) : false
  end
end
