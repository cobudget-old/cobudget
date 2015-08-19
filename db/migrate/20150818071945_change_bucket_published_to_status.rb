class ChangeBucketPublishedToStatus < ActiveRecord::Migration
  def change
    remove_column :buckets, :published
    add_column :buckets, :status, :string, default: 'draft'
  end
end
