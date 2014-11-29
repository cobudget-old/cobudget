class Round < ActiveRecord::Base
  belongs_to :group
  has_many :buckets
  has_many :allocations
  has_many :fixed_costs

  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :group, presence: true
end
