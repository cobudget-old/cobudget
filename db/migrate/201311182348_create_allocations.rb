class CreateAllocations < ActiveRecord::Migration
  def change
    create_table :allocations do |t|
      t.integer :amount_cents, :null => false, default: 0
      t.integer :user_id, :null => false
      t.integer :bucket_id, :null => false

      t.timestamps
    end
  end
end