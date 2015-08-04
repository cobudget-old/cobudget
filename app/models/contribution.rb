class Contribution < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :user

  validates :bucket_id, presence: true
  validates :user_id, presence: true
  validates :amount, numericality: { greater_than: 0 }

  before_save :reset_amount_if_exceeds_target

  private 
    def reset_amount_if_exceeds_target
      if bucket.total_contributions + self.amount > bucket.target
        self.amount = bucket.target - bucket.total_contributions
      end
    end
end