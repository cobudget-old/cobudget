class AddForcePasswordResetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :force_password_reset, :boolean
    User.reset_column_information
    User.update_all(force_password_reset: true)
  end
end
