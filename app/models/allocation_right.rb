class AllocationRight < ActiveRecord::Base
  belongs_to :allocator
  belongs_to :round

  monetize :amount_cents
end