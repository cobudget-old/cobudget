class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation :assign_uid_and_provider

  ### from previous authentication scheme ###
  # include TokenAuthenticable

  has_many :groups, through: :memberships
  has_many :memberships, foreign_key: "member_id", dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :contributions, dependent: :destroy
  has_many :buckets, dependent: :destroy

  validates :name, presence: true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/

  def name_and_email
    "#{name} <#{email}>"
  end

  def self.create_with_confirmation_token(email: )
    require 'securerandom'
    tmp_name = email[/[^@]+/]
    confirmation_token = SecureRandom.urlsafe_base64.to_s
    tmp_password = SecureRandom.hex
    self.create(name: tmp_name, email: email, password: tmp_password, confirmation_token: confirmation_token)
  end

  def is_admin_for?(group)
    Membership.where(group: group, member: self, archived_at: nil, is_admin: true).length > 0
  end

  def is_member_of?(group)
    Membership.where(group: group, member: self, archived_at: nil).length > 0
  end

  def has_set_up_account?
    confirmation_token.nil?
  end

  private
    def assign_uid_and_provider
      self.uid = self.email
      self.provider = "email"
    end
end
