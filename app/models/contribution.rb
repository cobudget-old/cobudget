class Contribution < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :user

  validates :bucket_id, presence: true
  validates :user_id, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validate :amount_cannot_overdraft_member

  before_save :lower_amount_if_exceeds_target
  after_save :update_bucket_status_if_funded

  def formatted_amount
    Money.new(amount * 100, currency_code).format
  end

  private
    def lower_amount_if_exceeds_target
      if bucket.total_contributions + self.amount > bucket.target
        self.amount = bucket.target - bucket.total_contributions
      end
    end

    def update_bucket_status_if_funded
      if bucket.status == 'live' && bucket.funded?
        bucket.update(status: 'funded')
      end
    end

    def amount_cannot_overdraft_member
      membership = Membership.find_by(member_id: user_id, group_id: bucket.group_id)
      if membership.raw_balance - amount < 0
        errors.add(:amount, "amount cannot overdraft member")
      end
    end

    def currency_code
      bucket.group.currency_code
    end
end
