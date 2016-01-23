class AddConfirmedAtToUsers < ActiveRecord::Migration
  def up
    add_column :users, :confirmed_at, :datetime, default: nil
    User.where(confirmation_token: nil).update_all(confirmed_at: DateTime.now.utc())
  end

  def down
    remove_column :users, :confirmed_at
  end
end
