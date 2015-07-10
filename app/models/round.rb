class Round < ActiveRecord::Base
  belongs_to :group
  has_many :buckets, dependent: :destroy
  has_many :allocations, dependent: :destroy
  has_many :fixed_costs, dependent: :destroy

  validates :name, presence: true
  validates :group, presence: true
  validate :start_and_end_go_together
  validate :starts_at_before_ends_at
  validate :has_valid_duration_validator

  def generate_new_members_and_allocations_from!(csv, admin)
    csv.each do |email, allocation|
      unless user = User.find_by_email(email)
        require 'securerandom'
        tmp_password = SecureRandom.hex(4)
        tmp_name = email[/[^@]+/]
        user = User.create(name: tmp_name, email: email, password: tmp_password)
        UserMailer.invite_email(user, admin, group, tmp_password).deliver_later!
      end

      unless group.members.find_by_id(user.id)
        group.members << user
        UserMailer.invite_to_group_email(user, admin, group).deliver_later!
      end

      allocations.create(user_id: user.id, amount: allocation.to_f)
    end
  end

  def published?
    starts_at.present? && ends_at.present?
  end

  def mode
    case 
      when !published? then "draft"
      when published? && Time.zone.now < starts_at then "proposal"
      when published? && Time.zone.now.between?(starts_at, ends_at) then "contribution"
      when published? && Time.zone.now > ends_at then "closed"
    end
  end

  def has_valid_duration?
    starts_at < ends_at
  end

  private
    def start_and_end_go_together
      if (starts_at.present? && ends_at.blank?) || (starts_at.blank? && ends_at.present?)
        errors.add(:starts_at, "starts_at and ends_at go together. They must both be present or neither be present.")
      end
    end

    def starts_at_before_ends_at
      if starts_at.present? && ends_at.present? && (starts_at > ends_at)
        errors.add(:starts_at, "starts_at must occur before ends_at.")
      end
    end

    def has_valid_duration_validator
      if published?
        unless has_valid_duration?
          errors.add(:starts_at, "and ends_at must both be present, and starts_at must occur before ends_at.") 
        end
      end
    end
end