class AddInitializedToGroups < ActiveRecord::Migration
  def up
    add_column :groups, :initialized, :boolean, default: false
    Group.update_all(initialized: true)
  end

  def down
    remove_column :groups, :initialized
  end
end
