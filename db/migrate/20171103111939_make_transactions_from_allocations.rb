class MakeTransactionsFromAllocations < ActiveRecord::Migration
  def change
    Group.find_each do |group|
      # Create new administrators user per group
      admin_user = User.create!({
        name: %(Administrators for #{group.name}),
        uid: %(admins-for-group-#{group.id}@non-existing.email),
        email: %(admins-for-group-#{group.id}@non-existing.email),
        password: "**NOLOGIN**",
        reset_password_token: %(admin-user-not-a-token-group-#{group.id}),
        confirmation_token: nil,
        confirmed_at: DateTime.now.utc()
        })
      handle_allocation_from_group(group.id, admin_user.id)
    end
  end

  def handle_allocation_from_group(group_id, signer_user_id)
    Allocation.where("group_id = ?", group_id).find_each do |allocation|
      memberships = Membership.where("member_id = ? AND group_id = ?", allocation.user_id, allocation.group_id)
      # We've seen cases with allocations and no memberships matching. 
      # If this happens we create a record in the anomalies table
      case memberships.count
      when 0
        allocation_as_json = {
          id: allocation.id,
          user_id: allocation.user_id,
          group_id: allocation.group_id,
          amount: allocation.amount,
          created_at: allocation.created_at,
          updated_at: allocation.updated_at
        }
        Anomaly.create!({
            tablename: 'allocations',
            data: allocation_as_json,
            reason: %(Not copied to transactions table since there was no membership record with user=#{allocation.user_id}, group=#{allocation.group_id}),
            who: %(Migration script #{name})
          })
      when 1
        Transaction.create!({
            datetime: allocation.created_at,
            from_account_id: memberships.first.incoming_account_id,
            to_account_id: memberships.first.status_account_id,
            user_id: signer_user_id,
            amount: allocation.amount
          })
      else
        raise %(Too many membership records for user=#{allocation.user_id}, group=#{allocation.group_id})
      end
    end
  end
end
