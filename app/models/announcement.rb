class Announcement < ActiveRecord::Base

  scope :tracked, -> (user) {
     from("announcements, announcement_trackers").
     where("user_id = ?", user.id).
     select("announcements.*, last_seen")
  }

  def seen
    has_attribute?(:last_seen) ? last_seen >= created_at : false
  end
end
