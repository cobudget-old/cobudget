namespace :cobudget do
  desc "These were failing as migrations because devise fields are not available."
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

  task :make_from_allocations => :environment do
    Group.find_each do |group|
      # Create new administrators user per group
      admin_user = User.create!({
        name: %(Administrators for #{group.name}),
        email: %(admins-for-group-#{group.id}@non-existing.email),
        password: (SecureRandom.base64 + SecureRandom.uuid).split('').shuffle.join,
        reset_password_token: %(admin-user-not-a-token-group-#{group.id})
        })
      admin_user.update(confirmation_token: nil, confirmed_at: DateTime.now.utc)
      handle_allocation_from_group(group.id, admin_user.id)
    end
  end

  task :make_from_contributions => :environment do
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
        Anomaly.create!({
            tablename: 'contributions',
            data: contribution_as_json,
            reason: %(Not copied to transactions table since there was no membership record with user=#{contribution.user_id}, group=#{bucket.group_id}),
            who: %(Migration script #{name})
          })
      when 1
        Transaction.create!({
            datetime: contribution.created_at,
            from_account_id: memberships.first.status_account_id,
            to_account_id: bucket.account_id,
            user_id: contribution.user_id,
            amount: contribution.amount.to_d
          })
      else
        raise %(Too many membership records for user=#{contribution.user_id}, group=#{bucket.group_id})
      end
    end
  end

  desc "These were failing as migrations because devise fields are not available."
  task :make_from_completed_buckets => :environment do
    # When a bucket is completed, we don't know if it's the bucket owner or the admin
    # who did the complete action. We invent a new user who's only job is to signify
    # that we don't know.
    dontknow_user = User.create!({
      name: "Bucket owner or administrator",
      id: "bucket-owner-or-adminstrator@non-existing.email",
      email: "bucket-owner-or-adminstrator@non-existing.email",
      password: (SecureRandom.base64 + SecureRandom.uuid).split('').shuffle.join,
      reset_password_token: "not-a-token-bucket-owner-or-admin",
      confirmation_token: nil,
      confirmed_at: DateTime.now.utc
      })
    dontknow_user.update(confirmation_token: nil, confirmed_at: DateTime.now.utc)
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
