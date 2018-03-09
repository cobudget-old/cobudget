class AddSubscribedToPersonalActivityToUsers < ActiveRecord::Migration
  def up
    add_column :users, :subscribed_to_personal_activity, :boolean, default: true
    User.all.each { |u| u.update(subscribed_to_personal_activity: true) }
  end

  def down
    remove_column :users, :subscribed_to_personal_activity    
  end
end
