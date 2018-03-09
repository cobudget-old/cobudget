class AddFundedAtToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :funded_at, :datetime
  end
end
