class MakeTransactionsFromAllocations < ActiveRecord::Migration
  def change
  	Allocation.find_each do |allocation|
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
      	Anomaly.create({
	      		table: 'allocations',
	      		data: allocation_as_json,
	      		reason: %(Not copied to transactions table since there was no membership record with user=#{allocation.user_id}, group=#{allocation.group_id}),
	      		who: %(Migration script #{name})
      		})
      when 1
	      Transaction.create({
	      		datetime: allocation.created_at,
	      		from_account_id: memberships.first.incoming_account_id,
	      		to_account_id: memberships.first.status_account_id,
	      		user_id: allocation.user_id,
	      		amount: allocation.amount
	      	})
	    else
	    	raise %(Too many membership records for user=#{allocation.user_id}, group=#{allocation.group_id})
	    end
    end
  end
end
