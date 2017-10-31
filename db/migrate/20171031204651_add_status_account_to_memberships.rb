class AddStatusAccountToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :status_account_id, :integer
    add_foreign_key :memberships, :accounts, column: :status_account_id
  end
end
