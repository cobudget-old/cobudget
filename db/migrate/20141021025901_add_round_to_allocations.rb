class AddRoundToAllocations < ActiveRecord::Migration
  def change
    add_reference :allocations, :round, index: true
    remove_column :allocations, :bucket_id, :integer
  end
end
