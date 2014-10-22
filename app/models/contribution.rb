class Contribution < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :user

  validates :bucket_id, presence: true
  validates :user_id, presence: true
end
