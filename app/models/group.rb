class Group < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
  has_one  :current_round, class_name: 'Round', order: "id DESC"

  def current_round_id
    current_round.id if current_round
  end
end
