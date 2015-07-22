class Group < ActiveRecord::Base
  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :memberships
  has_many :members, through: :memberships, source: :member

  validates_presence_of :name

  def add_admin(user)
    memberships.create!(member: user, is_admin: true)
  end

  def balance_for(user)
    allocation_sum = allocations.where(user: user)
                                .map { |allocation| allocation.amount }
                                .reduce(:+) || 0
    contribution_sum = buckets.map { |bucket| bucket.contributions }.flatten
                              .select { |contribution| contribution.user == user }
                              .map { |contribution| contribution.amount }
                              .reduce(:+) || 0
    balance = allocation_sum - contribution_sum
  end
end