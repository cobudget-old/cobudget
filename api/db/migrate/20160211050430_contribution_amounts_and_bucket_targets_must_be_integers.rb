class ContributionAmountsAndBucketTargetsMustBeIntegers < ActiveRecord::Migration
  def up
    change_column :contributions, :amount, :integer, null: false
    change_column :buckets, :target, :integer
  end

  def down
    change_column :contributions, :amount, :decimal, precision: 12, scale: 2, null: false
    change_column :buckets, :target, :decimal, precision: 12, scale: 2
  end
end
