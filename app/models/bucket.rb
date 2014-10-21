class Bucket < ActiveRecord::Base
  has_many :contributions
  belongs_to :round

  validates :name, presence: true
  validates :round_id, presence: true
  validates :target_cents, presence: true

  def contribution_total_cents
    contributions.sum(:amount_cents)
  end

  def percentage_funded
    percentage(contribution_total_cents, target_cents)
  end

  private
    def percentage(x, y)
      val = x.to_f / y.to_f * 100.0
      val.round
    end
end
