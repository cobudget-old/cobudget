class Group < ActiveRecord::Base
  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :memberships
  has_many :members, through: :memberships, source: :member

  validates_presence_of :name

  before_save :update_currency_symbol_if_currency_code_changed

  def add_admin(user)
    if members.include?(user)
      memberships.find_by(member: user).update(is_admin: true)
    else
      memberships.create(member: user, is_admin: true)
    end
  end

  def add_member(user)
    memberships.create!(member: user, is_admin: false)
  end

  def balance
    memberships.map { |m| m.balance }.reduce(:+) || 0
  end

  def formatted_balance
    Money.new(balance * 100, currency_code).format
  end

  def last_activity_at
    last_bucket = buckets.order(updated_at: :desc).limit(1).first
    last_bucket_updated_at = last_bucket ? last_bucket.updated_at : nil
    last_membership = memberships.order(updated_at: :desc).limit(1).first
    last_membership_updated_at = last_membership ? last_membership.updated_at : nil
    last_allocation = allocations.order(created_at: :desc).limit(1).first
    last_allocation_created_at = last_allocation ? last_allocation.created_at : nil
    last_contribution = Contribution.joins(:bucket).where(buckets: {id: buckets.pluck(:id)}).order(created_at: :desc).limit(1).first
    last_contribution_created_at = last_contribution ? last_contribution.created_at : nil
    last_comment = Comment.joins(:bucket).where(buckets: {id: buckets.pluck(:id)}).order(created_at: :desc).limit(1).first
    last_comment_updated_at = last_comment ? last_comment.created_at : nil
    [updated_at, last_bucket_updated_at, last_membership_updated_at, last_allocation_created_at, last_contribution_created_at, last_comment_updated_at].compact.max
  end

  private
    def update_currency_symbol_if_currency_code_changed
      if self.currency_code
        self.currency_symbol = Money.new(0, self.currency_code).symbol
      end
    end
end
