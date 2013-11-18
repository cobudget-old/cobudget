class AddTimestamps < ActiveRecord::Migration
  def change
    add_column :buckets, :created_at, :datetime
    add_column :buckets, :updated_at, :datetime
    add_column :budgets, :created_at, :datetime
    add_column :budgets, :updated_at, :datetime
  end
end