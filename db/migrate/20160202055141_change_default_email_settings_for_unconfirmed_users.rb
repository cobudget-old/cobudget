class ChangeDefaultEmailSettingsForUnconfirmedUsers < ActiveRecord::Migration
  def up
    change_column_default :users, :subscribed_to_personal_activity, false
    change_column_default :users, :subscribed_to_daily_digest, false
    change_column_default :users, :subscribed_to_participant_activity, false
    User.where(confirmed_at: nil).update_all(
      subscribed_to_personal_activity: false,
      subscribed_to_daily_digest: false,
      subscribed_to_participant_activity: false
    )
  end

  def down
    change_column_default :users, :subscribed_to_personal_activity, true
    change_column_default :users, :subscribed_to_daily_digest, true
    change_column_default :users, :subscribed_to_participant_activity, false
    User.where(confirmed_at: nil).update_all(
      subscribed_to_personal_activity: true,
      subscribed_to_daily_digest: true,
      subscribed_to_participant_activity: false
    )
  end
end
