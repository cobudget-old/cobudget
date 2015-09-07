class Contribution < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :user

  validates :bucket_id, presence: true
  validates :user_id, presence: true
  validates :amount, numericality: { greater_than: 0 }

  before_save :lower_amount_if_exceeds_target
  after_save :update_bucket_status_if_funded

  def formatted_amount
    Money.new(amount * 100, "USD").format
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
end