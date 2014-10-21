class Group < ActiveRecord::Base
  has_many :rounds, dependent: :destroy
  has_one  :latest_round, class_name: 'Round', order: "id DESC"

  after_create :create_initial_round

  def latest_round_id
    latest_round.id if latest_round
  end

private
  def create_initial_round
    rounds.create!(name: "Initial funding round")
  end
end
