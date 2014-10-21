class AddDescriptionToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :description, :text
  end
end
