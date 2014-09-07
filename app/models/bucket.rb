class Bucket < ActiveRecord::Base
  has_many :allocations

  def allocation_total_cents
    allocations.sum(:amount_cents)
  end
end