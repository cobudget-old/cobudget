class Allocation < ActiveRecord::Base
  belongs_to :round
  belongs_to :user

  validates :round_id, presence: true
  validates :user_id, presence: true, uniqueness: {scope: :round_id}
  validates :amount, presence: true

  def formatted_amount
    Money.new(amount.to_f * 100, "USD").format
  end

end
