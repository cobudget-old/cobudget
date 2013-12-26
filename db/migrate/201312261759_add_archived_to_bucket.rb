class AddArchivedToBucket < ActiveRecord::Migration
  def change
    add_column :buckets, :archived, :boolean, null: false, default: false

  end
end