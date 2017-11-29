class AddForeignKeysToTransactions < ActiveRecord::Migration
  def change
    add_foreign_key :transactions, :accounts, column: :from_account_id
    add_foreign_key :transactions, :accounts, column: :to_account_id
  end
end
