class ChangeMinMaxToInteger < ActiveRecord::Migration
  def change
    change_column :buckets, :minimum_cents, :integer
    change_column :buckets, :maximum_cents, :integer
  end
end