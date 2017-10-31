class AddAccountRefToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :account_id, :integer
    add_foreign_key :buckets, :accounts
  end
end
