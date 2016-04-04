class Bucket < ActiveRecord::Base
  has_many :contributions, -> { order("amount DESC") }, dependent: :destroy
  has_many :comments, dependent: :destroy
  belongs_to :group
  belongs_to :user

  validates :name, presence: true
  validates :description, presence: true
  validates :group_id, presence: true
  validates :user_id, presence: true
  validates :status, presence: true
  validate :target_cannot_be_updated_unless_idea, on: :update

  before_save :set_timestamp_if_status_updated

  def total_contributions
    contributions.sum(:amount)
  end

  def formatted_total_contributions
    Money.new(total_contributions * 100, currency_code).format
  end

  def formatted_target
    Money.new(target * 100, currency_code).format
  end

  def num_of_contributors
    contributions.map { |c| c.user_id }.uniq.length
  end

  def funded?
    total_contributions == target
  end

  def formatted_percent_funded
    "#{(total_contributions.to_f / target * 100).round}%"
  end

  def num_of_comments
    comments.length
  end

  def description_as_markdown
    renderer = Redcarpet::Render::HTML.new
    markdown = Redcarpet::Markdown.new(renderer, extensions = {})
    markdown.render(description).html_safe
  end

  def participants(exclude_author: nil, type: nil, subscribed: nil)
    case type
      when :contributors then ids = contributions.pluck(:user_id)
      when :comments then ids = comments.pluck(:user_id)
      else ids = (contributions.pluck(:user_id) + comments.pluck(:user_id)).uniq
    end
    users = User.where(id: ids)
    users = users.where(subscribed_to_participant_activity: true) if subscribed
    users = users.where.not(id: user_id) if exclude_author
    users.all
  end

  def contributors(exclude_author: nil)
    participants(exclude_author: exclude_author, type: :contributors)
  end

  def commenters(exclude_author: nil)
    participants(exclude_author: exclude_author, type: :commenters)
  end

  def author_name
    membership = user.membership_for(group)
    !membership || membership.archived? ? "[removed user]" : user.name
  end

  def is_editable_by?(member)
    member.is_admin_for?(group) || user == member
  end

  def archive!
    update(archived_at: DateTime.now.utc)
    if live_at.present?
      contributors.each do |funder|
        UserMailer.notify_funder_that_bucket_was_removed(funder: funder, bucket: self).deliver_now
      end
      contributions.destroy_all
    end
  end

  def archived?
    archived_at.present?
  end

  private
    def set_timestamp_if_status_updated
      if status_changed?
        case self.status
          when "live" then self.live_at = Time.now.utc
          when "funded" then self.funded_at = Time.now.utc
        end
      end
    end

    def currency_code
      group.currency_code
    end

    def target_cannot_be_updated_unless_idea
      if target_changed? && status != 'draft'
        errors.add(:target, "target can only be changed for draft buckets")
      end
    end
end
