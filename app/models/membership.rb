class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, class_name: "User"

  validates :group_id, presence: true
  validates :member_id, presence: true, uniqueness: { scope: :group_id }

  scope :archived, -> { where.not(archived_at: nil) }
  scope :active, -> { where(archived_at: nil) }

  def total_allocations
    group.allocations.where(user_id: member_id).sum(:amount)
  end

  def total_contributions
    group_bucket_ids = group.bucket_ids
    Contribution.where(bucket_id: group_bucket_ids, user_id: member_id).sum(:amount)
  end

  def balance
    total_allocations - total_contributions
  end

  def formatted_balance
    Money.new(balance * 100, currency_code).format
  end

  private
    def currency_code 
      group.currency_code
    end
end