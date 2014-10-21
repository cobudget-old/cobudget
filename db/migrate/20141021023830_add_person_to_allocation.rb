class AddPersonToAllocation < ActiveRecord::Migration
  def up
    add_reference :allocations, :person, index: true
    remove_column :allocations, :allocator_id
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
