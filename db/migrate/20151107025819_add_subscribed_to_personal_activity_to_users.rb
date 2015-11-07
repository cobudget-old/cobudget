class AddSubscribedToPersonalActivityToUsers < ActiveRecord::Migration
  def up
    add_column :users, :add_subscribed_to_personal_activity, :boolean, default: true
    User.all.each { |u| u.update(add_subscribed_to_personal_activity: true) }
  end

  def down
    remove_column :users, :add_subscribed_to_personal_activity    
  end
end
