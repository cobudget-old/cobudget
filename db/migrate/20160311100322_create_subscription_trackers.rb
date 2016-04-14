class CreateSubscriptionTrackers < ActiveRecord::Migration
  def up
    create_table :subscription_trackers do |t|
      t.belongs_to :user, index: true, null: false
      t.boolean :subscribed_to_email_notifications, default: false
      t.string :email_digest_delivery_frequency, default: "never"
      t.timestamps null: false
    end
  end

  def down
    drop_table :subscription_trackers
  end
end
