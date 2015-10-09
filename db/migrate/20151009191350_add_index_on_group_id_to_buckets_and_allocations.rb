class AddIndexOnGroupIdToBucketsAndAllocations < ActiveRecord::Migration
  def change
    add_index :buckets, :group_id
    add_index :allocations, :group_id
  end
end
