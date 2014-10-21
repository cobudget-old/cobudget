class Contribution < ActiveRecord::Base
  belongs_to :bucket

  validates :bucket_id, presence: true
end
