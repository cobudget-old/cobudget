class AddPublishedToBuckets < ActiveRecord::Migration
  def change 
    add_column :buckets, :published, :boolean, default: false
  end
end
