class AddIsSuperAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_super_admin, :boolean, default: false
  end
end
