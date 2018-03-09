class SetSubscriptionTrackerDefaultsForConfirmedUsers < ActiveRecord::Migration
  def up
    SubscriptionTracker.joins(:user).where.not(users: {confirmed_at: nil}).update_all(
      subscribed_to_email_notifications: true,
      email_digest_delivery_frequency: "weekly"
    )
  end

  def down
  end
end
