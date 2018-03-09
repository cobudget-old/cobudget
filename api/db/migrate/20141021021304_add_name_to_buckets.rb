class AddNameToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :name, :string
  end
end
