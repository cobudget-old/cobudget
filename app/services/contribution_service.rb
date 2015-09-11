class ContributionService
  def self.send_bucket_received_contribution_emails(contribution: )
    funder = contribution.user
    bucket = contribution.bucket
    bucket_author = bucket.user

    unless funder == bucket_author
      UserMailer.notify_author_that_bucket_received_contribution(contribution: contribution).deliver_later
    end

    if bucket.funded?
      BucketService.send_bucket_funded_emails(bucket: bucket)
    end
  end
end