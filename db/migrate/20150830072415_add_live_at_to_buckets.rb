class AddLiveAtToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :live_at, :datetime
  end
end
