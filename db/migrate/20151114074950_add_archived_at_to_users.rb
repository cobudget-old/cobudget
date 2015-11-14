class AddArchivedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :archived_at, :datetime
  end
end
