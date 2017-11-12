class BucketService
  def self.archive(bucket:, user:, exclude_author_from_email_notifications: false)
    ActiveRecord::Base.transaction do
      puts %(Bucket id=#{bucket.id} status=#{bucket.status} archived_at=#{bucket.archived_at} paid_at=#{bucket.paid_at})
      if bucket.is_funding? || bucket.is_funded?
        bucket.contributors(exclude_author: exclude_author_from_email_notifications).each do |funder|
          UserMailer.notify_funder_that_bucket_was_archived(funder: funder, bucket: bucket).deliver_later
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
      transaction = Transaction.create!({
          datetime: bucket.archived_at,
          from_account_id: transaction.to_account_id,
          to_account_id: transaction.from_account_id,
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
      puts %(Checked #{count} buckets. No errors found.)
    else
      puts %(Checked #{count} buckets. Errors found in #{error_buckets})
    end
  end
end
