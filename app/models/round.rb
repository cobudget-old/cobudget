class Round < ActiveRecord::Base
  belongs_to :group

  validates :name, presence: true
  validates :group, presence: true
end
