class Bucket < ActiveRecord::Base
  has_many :contributions, ->{ order("amount DESC") }, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :group
  belongs_to :user

  validates :name, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true

  def total_contributions
    contributions.sum(:amount)
  end

  def open_for_funding!(target:, ends_at:)
    update(target: target, status: 'live')
  end

  # TODO: eventually bring this stuff onto the client side
  def num_of_contributors
    # TODO: this should be the number of contributions with unique user_id
    contributions.length
  end
end