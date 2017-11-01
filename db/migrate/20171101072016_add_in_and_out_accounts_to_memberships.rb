class AddInAndOutAccountsToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :incoming_account_id, :integer
    add_column :memberships, :outgoing_account_id, :integer
    add_foreign_key :memberships, :accounts, column: :incoming_account_id
    add_foreign_key :memberships, :accounts, column: :outgoing_account_id

    # Create accounts for the new fields
    Membership.find_each do |membership|
      in_account = Account.new({group_id: membership.group_id})
      out_account = Account.new({group_id: membership.group_id})
      if in_account.save && out_account.save
        membership.incoming_account_id = in_account.id
        membership.outgoing_account_id = out_account.id
        membership.save!
      end
    end

  end
end
