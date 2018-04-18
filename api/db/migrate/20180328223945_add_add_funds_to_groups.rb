class AddAddFundsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :add_funds, :string
  end
end
