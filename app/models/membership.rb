class Membership < ActiveRecord::Base
  belongs_to :group
  belongs_to :member, class_name: "User"

  validates :group_id, presence: true
  validates :member_id, presence: true, uniqueness: { scope: :group_id }

  scope :archived, -> { where.not(archived_at: nil) }
  scope :active, -> { where(archived_at: nil) }

  after_create :update_member_if_this_is_their_first_membership

  def total_allocations
    group.allocations.where(user_id: member_id).sum(:amount)
  end

  def total_contributions
    group_bucket_ids = group.bucket_ids
    Contribution.where(bucket_id: group_bucket_ids, user_id: member_id).sum(:amount)
  end

  def raw_balance
    total_allocations - total_contributions
  end

  def balance
    raw_balance.floor
  end

  def formatted_balance
    Money.new(balance * 100, currency_code).format
  end

  def archived?
    archived_at
  end

  def active?
    !archived?
  end

  def archive!
    update(archived_at: DateTime.now.utc)
  end

  def reactivate!
    update(archived_at: nil)
  end

  private
    def currency_code
      group.currency_code
    end

    def update_member_if_this_is_their_first_membership
      unless member.has_ever_joined_a_group?
        member.update(joined_first_group_at: Time.now.utc)
      end
    end
end
