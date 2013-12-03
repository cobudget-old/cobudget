class AddBudgetIdToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :budget_id, :integer
  end
end