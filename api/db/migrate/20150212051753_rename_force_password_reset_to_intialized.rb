class RenameForcePasswordResetToIntialized < ActiveRecord::Migration
  def up
    rename_column :users, :force_password_reset, :initialized
    execute "UPDATE users SET initialized = NOT initialized"
  end

  def down
    rename_column :users, :initialized, :force_password_reset
    execute "UPDATE users SET force_password_reset = NOT force_password_reset"
  end
end
