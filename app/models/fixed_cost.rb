class FixedCost < ActiveRecord::Base
  belongs_to :round

  validates :round_id, presence: true
  validates :amount_cents, presence: true
end
