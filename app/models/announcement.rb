class Announcement < ActiveRecord::Base
  has_many :announcement_trackers
  has_many :users, through: :announcement_trackers

  scope :tracked, -> (user) {
    joins("LEFT JOIN (SELECT announcement_id, created_at
           FROM announcement_trackers
           WHERE user_id = #{user.id.to_s}) AS tracker
           ON announcements.id = tracker.announcement_id")
    .select("announcements.*, tracker.created_at AS seen_db")
  }     

  def seen
    has_attribute?(:seen_db) ? seen_db : nil
  end
end
