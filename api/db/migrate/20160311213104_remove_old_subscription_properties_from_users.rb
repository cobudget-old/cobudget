class RemoveOldSubscriptionPropertiesFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :subscribed_to_personal_activity, :boolean
    remove_column :users, :subscribed_to_daily_digest, :boolean
    remove_column :users, :subscribed_to_participant_activity, :boolean
  end

  def down
    add_column :users, :subscribed_to_personal_activity, :boolean, default: false
    add_column :users, :subscribed_to_daily_digest, :boolean, default: false
    add_column :users, :subscribed_to_participant_activity, :boolean, default: false
  end
end
