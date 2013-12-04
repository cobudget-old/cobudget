class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :owner_id, :null => false
      t.string   :description
      t.integer  :identifier
      t.integer :account_id
      t.integer :transfer_id
      t.integer :amount_cents

      t.timestamps
    end
  end
end