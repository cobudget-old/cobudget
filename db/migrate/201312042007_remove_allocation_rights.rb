class RemoveAllocationRights < ActiveRecord::Migration
  def change
    drop_table :allocation_rights
  end
end