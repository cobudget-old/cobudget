class Announcement < ActiveRecord::Base
  has_many :announcement_trackers
  has_many :users, through: :announcement_trackers
end
