class RemoveAllocations < ActiveRecord::Migration
  def change
    drop_table :allocations
  end
end