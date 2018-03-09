class AddSubscribedToParticipantActivityToUsers < ActiveRecord::Migration
  def up
    add_column :users, :subscribed_to_participant_activity, :boolean, default: false
    User.update_all(subscribed_to_participant_activity: false)
  end

  def down
    remove_column :users, :subscribed_to_participant_activity
  end
end
