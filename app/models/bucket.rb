class Bucket < ActiveRecord::Base
  has_many :contributions, ->{ order("amount DESC") }, dependent: :destroy
  belongs_to :group
  belongs_to :user

  validates :name, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true

  def total_contributions
    contributions.sum(:amount)
  end

  def publish!(target)
    update(target: target, published: true)
  end

  # TODO: eventually bring this stuff onto the client side
  def author_name
    user.name
  end

  def num_of_contributors
    contributions.length
  end

  def age_in_days
    (Time.zone.now - created_at).to_i / 1.day
  end
end