class AddMinMaxSponsorToBuckets < ActiveRecord::Migration
  def change
    add_column :buckets, :minimum_cents, :integer
    add_column :buckets, :maximum_cents, :integer
    add_column :buckets, :sponsor_id, :integer
  end
end