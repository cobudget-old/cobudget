class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation :assign_uid_and_provider

  ### from previous authentication scheme ###
  # include TokenAuthenticable

  has_many :allocations
  has_many :memberships, dependent: :destroy, foreign_key: "member_id"

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

  # (EL) I dont think this is necessary anymore
  def is_admin_for?(group)
    group.memberships.where(is_admin: true).where(member_id: id).exists?
  end

  # (EL) I dont think this is necessary anymore
  def is_member_of?(group)
    group.members.include?(self)
  end

  private
    def assign_uid_and_provider
      self.uid = self.email
      self.provider = "email"
    end
end
