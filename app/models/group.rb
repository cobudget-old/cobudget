class Group < ActiveRecord::Base
  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :memberships
  has_many :members, through: :memberships, source: :member

  validates_presence_of :name

  before_save :update_currency_symbol_if_currency_code_changed

  def add_admin(user)
    if members.include?(user)
      memberships.find_by(member: user).update(is_admin: true)
    else
      memberships.create(member: user, is_admin: true)
    end
  end

  def add_member(user)
    memberships.create!(member: user, is_admin: false)
  end

  def balance
    memberships.map { |m| m.balance }.reduce(:+) || 0
  end

  def formatted_balance
    Money.new(balance * 100, currency_code).format
  end

  private
    def update_currency_symbol_if_currency_code_changed
      if self.currency_code
        self.currency_symbol = Money.new(0, self.currency_code).symbol
      end
    end
end
