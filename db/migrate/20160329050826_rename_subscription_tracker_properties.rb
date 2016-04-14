class RenameSubscriptionTrackerProperties < ActiveRecord::Migration
  def change
    rename_column :subscription_trackers, :funding_for_your_bucket, :contributions_to_live_buckets_user_authored
    rename_column :subscription_trackers, :your_bucket_fully_funded, :funded_buckets_user_authored
    rename_column :subscription_trackers, :comment_on_your_bucket, :comments_on_buckets_user_authored
    rename_column :subscription_trackers, :comment_on_bucket_you_participated_in, :comments_on_buckets_user_participated_in
    rename_column :subscription_trackers, :bucket_started_funding, :new_live_buckets
    rename_column :subscription_trackers, :bucket_idea_created, :new_draft_buckets
    rename_column :subscription_trackers, :funding_for_a_bucket_you_participated_in, :contributions_to_live_buckets_user_participated_in
    rename_column :subscription_trackers, :bucket_fully_funded, :new_funded_buckets
  end
end
