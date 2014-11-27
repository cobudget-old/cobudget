class FixedCost < ActiveRecord::Base
  belongs_to :round

  validates :name, presence: true
  validates :round_id, presence: true
  validates :amount_cents, presence: true
  validates :description, presence: true
end
