class Group < ActiveRecord::Base
  has_many :rounds, -> { order("ends_at DESC") }, dependent: :destroy
  has_one  :latest_round, -> { order("id DESC") }, class_name: 'Round'
  has_many :memberships
  has_many :members, through: :memberships, source: :member

  validates_presence_of :name

  def add_admin(user)
    memberships.create!(member: user, is_admin: true)
  end
end