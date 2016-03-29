class CreateSubscriptionTrackers < ActiveRecord::Migration
  def up
    create_table :subscription_trackers do |t|
      t.belongs_to :user, index: true, null: false

      t.boolean :comments_on_buckets_user_authored, default: true, null: false
      t.boolean :comments_on_buckets_user_participated_in, default: true, null: false

      t.boolean :new_draft_buckets, default: true, null: false
      t.boolean :new_live_buckets, default: true, null: false
      t.boolean :new_funded_buckets, default: true, null: false

      t.boolean :contributions_to_live_buckets_user_authored, default: true, null: false
      t.boolean :contributions_to_live_buckets_user_participated_in, default: true, null: false
      t.boolean :funded_buckets_user_authored, default: true, null: false

      t.datetime :recent_activity_last_fetched_at
      t.string :notification_frequency, default: "hourly", null: false

      t.timestamps null: false
    end

    User.all.each do |user|
      SubscriptionTracker.create(user: user, recent_activity_last_fetched_at: DateTime.now.utc.beginning_of_hour) unless user.subscription_tracker
    end
  end

  def down
    drop_table :subscription_trackers
  end
end
