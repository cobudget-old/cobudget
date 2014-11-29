class Group < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
  has_one  :latest_round, class_name: 'Round', order: "id DESC"
  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def latest_round_id
    latest_round.id if latest_round
  end
end
