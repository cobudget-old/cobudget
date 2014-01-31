class RenameTransferToTransaction < ActiveRecord::Migration
  def change
    rename_column :entries, :transfer_id, :transaction_id
    rename_table :transfers, :transactions
  end
end
