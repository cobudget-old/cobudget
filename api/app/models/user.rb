require 'securerandom'

class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include DeviseTokenAuth::Concerns::User

  before_validation :assign_uid_and_provider
  after_create :create_default_subscription_tracker

  has_many :groups, through: :memberships
  has_many :memberships, foreign_key: "member_id", dependent: :destroy
  has_one :subscription_tracker,                   dependent: :destroy
  has_many :allocations,                           dependent: :destroy
  has_many :comments,                              dependent: :destroy
  has_many :contributions,                         dependent: :destroy
  has_many :buckets,                               dependent: :destroy
  has_many :transactions
  has_one :announcement_tracker,                   dependent: :destroy

  scope :with_active_announcements, -> { joins(:announcements).where(announcements: {title: nil}) }
  scope :with_active_memberships, -> { joins(:memberships).where(memberships: {archived_at: nil}).distinct }

  validates :name, presence: true
  validates_format_of :email, :with => /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/
  validate :password_requirements_are_met

  def name_and_email
    "#{name} <#{email}>"
  end

  def self.create_with_confirmation_token(email:, password: nil, name: nil)
    name = name || email[/[^@]+/]
    tmp_password = password || (SecureRandom.base64 + SecureRandom.random_bytes + SecureRandom.uuid).split("").shuffle.join
    new_user = self.create(name: name, email: email, password: tmp_password)
    new_user.generate_confirmation_token!
    new_user
  end

  def is_admin_for?(group)
    is_super_admin || (Membership.where(group: group, member: self, archived_at: nil, is_admin: true).length > 0)
  end

  def is_member_of?(group)
    is_super_admin || (Membership.where(group: group, member: self, archived_at: nil).length > 0)
  end

  def membership_for(group)
    memberships.find_by(group_id: group.id)
  end

  def generate_confirmation_token!
    self.update(confirmation_token: SecureRandom.urlsafe_base64.to_s, confirmed_at: nil)
  end

  def confirm!
    update(confirmation_token: nil, confirmed_at: DateTime.now.utc())
    subscription_tracker.update(
      subscribed_to_email_notifications: true,
      email_digest_delivery_frequency: "weekly"
    )
  end

  def confirmed?
    confirmed_at.present?
  end

  def has_ever_joined_a_group?
    joined_first_group_at.present?
  end

  def generate_reset_password_token!
    update(reset_password_token: SecureRandom.urlsafe_base64.to_s)
  end

  def active_groups
    Group.joins(:memberships).where(memberships: {member: self, archived_at: nil})
  end

  private
    def assign_uid_and_provider
      self.uid = self.email
      self.provider = "email"
    end

    def create_default_subscription_tracker
      SubscriptionTracker.create(user: self)
    end

    def password_requirements_are_met
      rules = {
        " must contain at least one lowercase letter"  => /[a-z]+/,
        " must contain at least one uppercase letter"  => /[A-Z]+/,
        " must contain at least one digit"             => /\d+/,
        " must contain at least one special character" => /[^A-Za-z0-9]+/,
        " must be at least 10 characters long"         => /.{10,}/
      }

      rules.each do |message, regex|
        next if password.blank?
        errors.add( :password, message ) unless password.match( regex )
      end
    end
end
