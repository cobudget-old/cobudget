class Allocation < ActiveRecord::Base
  belongs_to :group
  belongs_to :user

  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :amount, presence: true
  validates_numericality_of :amount, other_than: 0

  def formatted_amount
    Money.new(amount.to_f * 100, currency_code).format
  end

  private
    def currency_code
      group.currency_code
    end
end
