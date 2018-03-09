class AllocationsBelongToGroup < ActiveRecord::Migration
  def change
    remove_reference :allocations, :round
    add_reference :allocations, :group
  end
end
