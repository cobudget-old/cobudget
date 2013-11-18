class CreateAllocationRights < ActiveRecord::Migration
  def change
    create_table :allocation_rights do |t|
      t.integer :amount_cents, :null => false, default: 0
      t.integer :user_id, :null => false
      t.integer :budget_id, :null => false

      t.timestamps
    end
  end
end