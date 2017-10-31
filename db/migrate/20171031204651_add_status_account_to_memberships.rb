class AddStatusAccountToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :status_account_id, :integer
    add_foreign_key :memberships, :accounts, column: :status_account_id

    # Create accounts for the new field
    Membership.find_each do |membership|
      account = Account.new({group_id: membership.group_id})
      if account.save
        membership.status_account_id = account.id
        membership.save!
      end
    end
  end
end
