class AddFundingFreezeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :funding_freeze, :boolean, :default => false
  end
end
