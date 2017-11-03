class AddInAndOutAccountsToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :incoming_account_id, :integer
    add_column :memberships, :outgoing_account_id, :integer
    add_foreign_key :memberships, :accounts, column: :incoming_account_id
    add_foreign_key :memberships, :accounts, column: :outgoing_account_id

    # Create accounts for the new fields
    Membership.reset_column_information
    Membership.find_each do |membership|
      in_account = Account.create({group_id: membership.group_id})
      out_account = Account.create({group_id: membership.group_id})
      membership.incoming_account_id = in_account.id
      membership.outgoing_account_id = out_account.id
      membership.save!
    end
  end
end
