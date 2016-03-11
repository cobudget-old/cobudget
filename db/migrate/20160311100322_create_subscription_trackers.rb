class CreateSubscriptionTrackers < ActiveRecord::Migration
  def up
    create_table :subscription_trackers do |t|
      t.belongs_to :user, index: true, null: false

      t.boolean :comment_on_your_bucket, default: true, null: false
      t.boolean :comment_on_bucket_you_participated_in, default: true, null: false

      t.boolean :bucket_idea_created, default: true, null: false
      t.boolean :bucket_started_funding, default: true, null: false
      t.boolean :bucket_fully_funded, default: true, null: false

      t.boolean :funding_for_your_bucket, default: true, null: false
      t.boolean :funding_for_a_bucket_you_participated_in, default: true, null: false
      t.boolean :your_bucket_fully_funded, default: true, null: false

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
