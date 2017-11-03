class AddStatusAccountToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :status_account_id, :integer
    add_foreign_key :memberships, :accounts, column: :status_account_id

    # Create accounts for the new field
    Membership.reset_column_information
    Membership.find_each do |membership|
      account = Account.create!({group_id: membership.group_id})
      membership.status_account_id = account.id
      membership.save!
    end
  end
end
