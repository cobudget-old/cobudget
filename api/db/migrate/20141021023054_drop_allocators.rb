class DropAllocators < ActiveRecord::Migration
  def up
    remove_foreign_key(:allocations, name: 'allocations_allocator_id_fk')
    drop_table :allocation_rights
    drop_table :reserve_buckets
    drop_table :allocators
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
