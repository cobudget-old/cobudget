class Announcement < ActiveRecord::Base

  scope :tracked, -> (user) {
     from("announcements, announcement_trackers").
     where("user_id = ? and (expired_at is NULL or expired_at > ?)", user.id, Time.now).
     order(created_at: :desc).
     select("announcements.*, last_seen")
  }

  def seen
    has_attribute?(:last_seen) ? last_seen >= created_at : false
  end
end
