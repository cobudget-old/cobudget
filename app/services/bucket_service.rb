class BucketService
  def self.archive(bucket, user, exclude_author_from_email_notifications: false)
    ActiveRecord::Base.transaction do
      if bucket.is_idea? || bucket.is_funding? || bucket.is_funded?
        bucket.contributors(exclude_author: exclude_author_from_email_notifications).each do |funder|
          # Don't notify archived members
          if !Membership.find_by(group_id: bucket.group_id, member_id: funder.id).archived_at
            UserMailer.notify_funder_that_bucket_was_archived(funder: funder, bucket: bucket).deliver_later
          end
        end
        bucket.update(archived_at: DateTime.now.utc)
        bucket.contributions.destroy_all
        reverse_transactions(bucket, user)
        bucket.update(status: 'refunded')
      end
    end
  end

  def self.reverse_transactions(bucket, user)
    Transaction.where("to_account_id = ?", bucket.account_id).find_each do |transaction|
      # Find the membership the money is returned to and check if it's archived
      m = Membership.find_by status_account_id: transaction.from_account_id
      if m.archived_at
        group = Group.find(m.group_id)
        group_membership = group.ensure_group_account_exist()
        to_account = group_membership.status_account_id
        Allocation.create!(user: m.member, group: group_membership.group, amount: -transaction.amount)
        Allocation.create!(user: group_membership.member, group: group_membership.group, amount: transaction.amount)
        group.for_each_admin do |admin|
          UserMailer.notify_admins_funds_are_returned_to_group_account(admin: admin.member,
            bucket: bucket, done_by: user, archived_member: m.member, amount: transaction.amount,
            group_account: group_membership.member).deliver_later
        end
      else
        to_account = transaction.from_account_id
      end
      Transaction.create!({
          datetime: bucket.archived_at,
          from_account_id: transaction.to_account_id,
          to_account_id: to_account,
          user_id: user.id,
          amount: transaction.amount
        })
    end
  end

  def self.check_all_buckets
    error_buckets = []
    count = 0
    Bucket.find_each do |bucket|
      count += 1
      if !bucket.transactions_data_ok?
        error_buckets.push(bucket.id)
      end
    end
    if error_buckets.length == 0
      %(Checked #{count} buckets. No errors found.)
    else
      %(Checked #{count} buckets. Errors found in #{error_buckets})
    end
  end
end
