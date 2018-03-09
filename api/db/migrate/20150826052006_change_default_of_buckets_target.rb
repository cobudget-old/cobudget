class ChangeDefaultOfBucketsTarget < ActiveRecord::Migration
  def change
    change_column_default :buckets, :target, nil
  end
end
