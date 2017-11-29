class AddStatusAccountToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :status_account_id, :integer
    add_foreign_key :groups, :accounts, column: :status_account_id

    # Create accounts for the new field
    Group.reset_column_information
    Group.find_each do |group|
      account = Account.create!({group_id: group.id})
      group.update(status_account_id: account.id)
      group_user = User.find_by(uid: %(group-#{group.id}@non-existing.email))
      if group_user 
        group_membership = Membership.find_by(group_id: id, member_id: group_user.id)
        if group_membership
          Account.find(group_membership.status_account_id).change_account_to(acount.id)
          Membership.destroy(group_membership.id)
        end
        User.destroy(group_user.id)
      end
    end
  end
end
