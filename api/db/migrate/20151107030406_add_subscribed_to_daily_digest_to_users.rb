class AddSubscribedToDailyDigestToUsers < ActiveRecord::Migration
  def up
    add_column :users, :subscribed_to_daily_digest, :boolean, default: true
    User.update_all(subscribed_to_daily_digest: true)
  end

  def down
    remove_column :users, :subscribed_to_daily_digest, :boolean, default: true
  end
end
