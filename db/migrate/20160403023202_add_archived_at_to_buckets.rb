class AddArchivedAtToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :archived_at, :datetime
  end
end
