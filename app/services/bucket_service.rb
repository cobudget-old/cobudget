class BucketService
  def self.archive(bucket:, exclude_author_from_email_notifications: false)
    bucket.update(archived_at: DateTime.now.utc)
    if bucket.status == 'live' or 'funded'
      bucket.contributors(exclude_author: exclude_author_from_email_notifications).each do |funder|
        UserMailer.notify_funder_that_bucket_was_archived(funder: funder, bucket: bucket).deliver_now
      end
      bucket.contributions.destroy_all
      bucket.update(status: 'refunded')
    end
  end
end
