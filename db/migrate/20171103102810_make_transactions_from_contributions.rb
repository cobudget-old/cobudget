class MakeTransactionsFromContributions < ActiveRecord::Migration
  def change
  	Contribution.find_each do |contribution|
	    bucket = Bucket.find(contribution.bucket_id)
      memberships = Membership.where("member_id = ? AND group_id = ?", contribution.user_id, bucket.group_id)
      # We've seen cases with contributions and no memberships matching. 
      # If this happens we create a record in the anomalies table
      case memberships.count
      when 0
      	contribution_as_json = {
      		id: contribution.id,
      		user_id: contribution.user_id,
      		bucket_id: contribution.bucket_id,
      		amount: contribution.amount,
      		created_at: contribution.created_at,
      		updated_at: contribution.updated_at
      	}
      	Anomaly.new({
	      		table: 'contributions',
	      		data: contribution_as_json,
	      		reason: %(Not copied to transactions table since there was no membership record with user=#{contribution.user_id}, group=#{bucket.group_id}),
	      		who: %(Migration script #{name})
      		}).save!
      when 1
	      Transaction.new({
	      		datetime: contribution.created_at,
	      		from_account_id: memberships.first.status_account_id,
	      		to_account_id: bucket.account_id,
	      		user_id: contribution.user_id,
	      		amount: contribution.amount.to_d
	      	}).save!
	    else
	    	raise %(Too many membership records for user=#{contribution.user_id}, group=#{bucket.group_id})
	    end
    end
  end
end
