class Allocation < ActiveRecord::Base
  belongs_to :round
  belongs_to :user

  validates :round_id, presence: true
  validates :user_id, presence: true, uniqueness: {scope: :round}
end
