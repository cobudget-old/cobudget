class Bucket < ActiveRecord::Base
  has_many :contributions, ->{ order("amount DESC") }, dependent: :destroy
  belongs_to :round
  belongs_to :user

  validates :name, presence: true
  validates :round_id, presence: true
  validates :user_id, presence: true
  validates :target, presence: true
end
