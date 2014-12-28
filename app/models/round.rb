class Round < ActiveRecord::Base
  belongs_to :group
  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :fixed_costs, dependent: :destroy

  validates :name, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validates :group, presence: true
end
