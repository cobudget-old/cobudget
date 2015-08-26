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

  # funding_closes_at, need to think more about the implications of setting this
  def open_for_funding(target:, funding_closes_at:)
    update(target: target, status: 'live', funding_closes_at: funding_closes_at)
  end

  # TODO: eventually bring this stuff onto the client side
  def num_of_contributors
    contributions.map { |c| c.user_id }.uniq.length
  end

  def funded?
    total_contributions == target
  end
end