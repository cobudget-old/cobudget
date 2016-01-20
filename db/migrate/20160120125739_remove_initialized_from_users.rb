class RemoveInitializedFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :initialized
  end

  def down
    add_column :users, :initialized, :boolean, default: true, null: false
  end
end
