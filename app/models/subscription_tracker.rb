class SubscriptionTracker < ActiveRecord::Base
  belongs_to :user
  validates :email_digest_delivery_frequency, inclusion: { in: %w(never daily weekly) }
end
