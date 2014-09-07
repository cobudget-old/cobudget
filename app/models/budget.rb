class Budget < ActiveRecord::Base
  has_many :rounds, dependent: :destroy

  def current_round_id
    current_round = rounds.last
    current_round.id if current_round
  end
end