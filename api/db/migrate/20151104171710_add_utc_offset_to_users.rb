class AddUtcOffsetToUsers < ActiveRecord::Migration
  def change
    add_column :users, :utc_offset, :integer, default: 0
  end
end
