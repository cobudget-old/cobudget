class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, class_name: "User"

  validates :group_id, presence: true
  validates :member_id, presence: true, uniqueness: { scope: :group_id }

  def total_allocations
    group.allocations.where(user_id: member_id).sum(:amount)
  end

  def total_contributions
    group_bucket_ids = group.bucket_ids
    Contribution.where(bucket_id: group_bucket_ids, user_id: member_id).sum(:amount)
  end
end