class Allocation < ActiveRecord::Base
  belongs_to :round
  belongs_to :person

  validates :round_id, presence: true
  validates :person_id, presence: true, uniqueness: {scope: :round}
end
