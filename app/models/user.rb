class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include TokenAuthenticable

  has_many :allocations

  validates :name, presence: true

  def name_and_email
    "#{name} <#{email}>"
  end

  def is_admin_for?(group)
    group.memberships.where(is_admin: true).where(member_id: id).exists?
  end

  def is_member_of?(group)
    group.members.include?(self)
  end
end
