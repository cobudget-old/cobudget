class AddUserToBuckets < ActiveRecord::Migration
  def change
    add_reference :buckets, :user, index: true
  end
end
