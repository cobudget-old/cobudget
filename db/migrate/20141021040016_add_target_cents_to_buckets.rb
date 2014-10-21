class AddTargetCentsToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :target_cents, :integer
  end
end
