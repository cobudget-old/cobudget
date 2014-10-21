class Bucket < ActiveRecord::Base
  has_many :allocations
  belongs_to :round

  validates :name, presence: true
  validates :round, presence: true

  def allocation_total_cents
    allocations.sum(:amount_cents)
  end
end
