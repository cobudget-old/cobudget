class BucketsBelongToGroup < ActiveRecord::Migration
  def change
    remove_reference :buckets, :round
    add_reference :buckets, :group
  end
end
