class Allocation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :amount, presence: true

  def formatted_amount
    Money.new(amount.to_f * 100, "USD").format
  end
end