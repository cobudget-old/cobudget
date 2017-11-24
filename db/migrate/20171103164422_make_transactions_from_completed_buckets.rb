class MakeTransactionsFromCompletedBuckets < ActiveRecord::Migration
  def change
  	# When a bucket is completed, we don't know if it's the bucket owner or the admin
  	# who did the complete action. We invent a new user who's only job is to signify
  	# that we don't know.
	  dontknow_user = User.create!({
      name: "Bucket owner or administrator",
      uid: "bucketowneroradminstrator@noemail.co",
      email: "bucketowneroradminstrator@noemail.co",
      password: "**NOLOGIN**",
      reset_password_token: "not-a-token-bucket-owner-or-admin",
      confirmation_token: nil,
      confirmed_at: DateTime.now.utc()
      })

  	# Go through all completed buckets
  	Bucket.where("status = 'funded' AND paid_at IS NOT NULL").find_each do |bucket|
	  	memberships = Membership.where("member_id = ? AND group_id = ?", bucket.user_id, bucket.group_id)
	    case memberships.count
	    when 0
	      bucket_as_json = {
	        id: bucket.id,
	        user_id: bucket.user_id,
	        group_id: bucket.group_id,
	        status: bucket.status,
	        archived_at: bucket.archived_at,
	        paid_at: bucket.paid_at,
	        created_at: allocation.created_at,
	        updated_at: allocation.updated_at
	      }
	      Anomaly.create!({
	          tablename: 'buckets',
	          data: bucket_as_json,
	          reason: %(Transaction for bucket completion not created since there was no membership record with user=#{bucket.user_id}, group=#{bucket.group_id}),
	          who: %(Migration script #{name})
	        })
	    when 1
	      Transaction.create!({
	          datetime: bucket.paid_at,
	          from_account_id: bucket.account_id,
	          to_account_id: memberships.first.outgoing_account_id,
	          user_id: dontknow_user.id,
	          amount: bucket.total_contributions
	        })
	    else
	      raise %(Too many membership records for user=#{allocation.user_id}, group=#{allocation.group_id})
	    end
	  end
  end
end
