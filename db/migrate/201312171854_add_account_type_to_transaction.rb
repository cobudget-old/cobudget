class AddAccountTypeToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :account_type, :string
  end
end