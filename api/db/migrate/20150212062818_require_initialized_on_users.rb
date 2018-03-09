class RequireInitializedOnUsers < ActiveRecord::Migration
  def up
    User.where(initialized: nil).update_all(initialized: true)
    change_column :users, :initialized, :boolean, default: true, null: false
  end
  def down
    change_column :users, :initialized, :boolean, default: false, null: true
  end
end
