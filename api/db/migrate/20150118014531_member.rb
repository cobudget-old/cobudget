class Member < ActiveRecord::Migration
  def change
    rename_column :memberships, :user_id, :member_id
  end
end
