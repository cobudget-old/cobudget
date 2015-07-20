class Group < ActiveRecord::Base
  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :memberships
  has_many :members, through: :memberships, source: :member

  validates_presence_of :name

  def add_admin(user)
    memberships.create!(member: user, is_admin: true)
  end
end