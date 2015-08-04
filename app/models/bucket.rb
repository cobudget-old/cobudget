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
end