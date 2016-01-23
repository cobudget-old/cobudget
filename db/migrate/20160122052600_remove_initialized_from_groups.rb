class RemoveInitializedFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :initialized
  end
end
