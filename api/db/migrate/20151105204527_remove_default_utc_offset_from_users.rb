class RemoveDefaultUtcOffsetFromUsers < ActiveRecord::Migration
  def change
    change_column_default :users, :utc_offset, nil
  end
end
