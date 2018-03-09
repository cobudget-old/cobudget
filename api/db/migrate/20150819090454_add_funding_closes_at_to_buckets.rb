class AddFundingClosesAtToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :funding_closes_at, :datetime
  end
end
