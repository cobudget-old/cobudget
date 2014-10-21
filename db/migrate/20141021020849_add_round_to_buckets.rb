class AddRoundToBuckets < ActiveRecord::Migration
  def change
    add_reference :buckets, :round, index: true
  end
end
