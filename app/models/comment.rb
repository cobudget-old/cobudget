class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :bucket

  validates :user_id, presence: true
  validates :bucket_id, presence: true
end