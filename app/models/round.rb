class Round < ActiveRecord::Base
  belongs_to :group
  has_many :buckets
  has_many :allocations
  has_many :fixed_costs

  validates :name, presence: true
  validates :group, presence: true
end
