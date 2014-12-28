class Group < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
  has_one  :latest_round, class_name: 'Round', order: "id DESC"
  has_many :memberships
  has_many :members, through: :memberships, source: :user
end
