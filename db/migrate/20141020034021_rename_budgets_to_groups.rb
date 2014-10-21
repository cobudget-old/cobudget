class RenameBudgetsToGroups < ActiveRecord::Migration
  def change
    rename_table :budgets, :groups
  end
end
