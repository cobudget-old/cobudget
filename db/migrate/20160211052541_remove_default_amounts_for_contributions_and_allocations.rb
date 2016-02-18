class RemoveDefaultAmountsForContributionsAndAllocations < ActiveRecord::Migration
  def up
    change_column_default :allocations, :amount, nil
    change_column_default :contributions, :amount, nil
    change_column_null :allocations, :amount, false
  end

  def down
    change_column_default :allocations, :amount, 0
    change_column_default :contributions, :amount, 0.0
    change_column_null :allocations, :amount, true
  end
end
