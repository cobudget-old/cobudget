class Contribution < ActiveRecord::Base
  belongs_to :bucket
  belongs_to :user

  validates :bucket_id, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :bucket_id }
  validates :amount_cents, numericality: { greater_than: 0 }

  def self.for_round(round_id)
    joins(bucket: :round).where('buckets.round_id = ?', round_id)
  end
end
