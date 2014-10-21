class RoundsBelongToGroups < ActiveRecord::Migration
  def change
    remove_column :rounds, :budget_id, :integer
    add_reference :rounds, :group, index: true, null: false
  end
end
