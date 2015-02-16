class DefaultInitializedToFalse < ActiveRecord::Migration
  def change
    change_column :users, :initialized, :boolean, default: false
  end
end
