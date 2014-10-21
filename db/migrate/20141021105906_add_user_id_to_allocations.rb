class AddUserIdToAllocations < ActiveRecord::Migration
  def change
    rename_column :allocations, :person_id, :user_id
  end
end
