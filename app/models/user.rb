class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation :assign_uid_and_provider

  ### from previous authentication scheme ###
  # include TokenAuthenticable

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

  private
    def assign_uid_and_provider
      self.uid = self.email
      self.provider = "email"
    end
end
