class UnsubscribeUnconfirmedUsersFromActivityEmails < ActiveRecord::Migration
  def up
    SubscriptionTracker.joins(:user).where(users: {confirmed_at: nil}).update_all(notification_frequency: "never")
    change_column_default :subscription_trackers, :notification_frequency, "never"
  end

  def down
    SubscriptionTracker.joins(:user).where(users: {confirmed_at: nil}).update_all(notification_frequency: "hourly")
    change_column_default :subscription_trackers, :notification_frequency, "hourly"
  end
end
