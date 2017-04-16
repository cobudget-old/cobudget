class AddPaidAtToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :paid_at, :datetime
  end
end
