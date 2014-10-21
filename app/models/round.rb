class Round < ActiveRecord::Base
  belongs_to :group
  has_many :buckets

  validates :name, presence: true
  validates :group, presence: true
end
