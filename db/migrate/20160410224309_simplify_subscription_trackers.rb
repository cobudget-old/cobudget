class SimplifySubscriptionTrackers < ActiveRecord::Migration
  def up
    remove_column :subscription_trackers, :comments_on_buckets_user_authored
    remove_column :subscription_trackers, :comments_on_buckets_user_participated_in
    remove_column :subscription_trackers, :new_draft_buckets
    remove_column :subscription_trackers, :new_live_buckets
    remove_column :subscription_trackers, :new_funded_buckets
    remove_column :subscription_trackers, :contributions_to_live_buckets_user_authored
    remove_column :subscription_trackers, :contributions_to_live_buckets_user_participated_in
    remove_column :subscription_trackers, :funded_buckets_user_authored

    add_column :subscription_trackers, :subscribed_to_email_notifications, :boolean, default: false
    add_column :subscription_trackers, :email_digest_delivery_frequency, :string, default: "never"

    remove_column :subscription_trackers, :recent_activity_last_fetched_at
    remove_column :subscription_trackers, :notification_frequency
  end

  def down
    add_column :subscription_trackers, :comments_on_buckets_user_authored, :boolean, default: true
    add_column :subscription_trackers, :comments_on_buckets_user_participated_in, :boolean, default: true
    add_column :subscription_trackers, :new_draft_buckets, :boolean, default: true
    add_column :subscription_trackers, :new_live_buckets, :boolean, default: true
    add_column :subscription_trackers, :new_funded_buckets, :boolean, default: true
    add_column :subscription_trackers, :contributions_to_live_buckets_user_authored, :boolean, default: true
    add_column :subscription_trackers, :contributions_to_live_buckets_user_participated_in, :boolean, default: true
    add_column :subscription_trackers, :funded_buckets_user_authored, :boolean, default: true

    remove_column :subscription_trackers, :subscribed_to_email_notifications
    remove_column :subscription_trackers, :email_digest_delivery_frequency

    add_column :subscription_trackers, :recent_activity_last_fetched_at
    SubscriptionTracker.update_all(recent_activity_last_fetched_at: DateTime.now.utc.beginning_of_hour)

    add_column :subscription_trackers, :notification_frequency, :string, default: "never"
  end
end
