class BucketService
  def self.send_bucket_live_emails(bucket: )
    bucket.group.memberships.each do |membership|
      member = membership.member
      if membership.balance > 0
        UserMailer.notify_member_with_balance_that_bucket_is_live(bucket: bucket, member: member).deliver_later
      else
        UserMailer.notify_member_with_zero_balance_that_bucket_is_live(bucket: bucket, member: member).deliver_later
      end
    end
  end

  def self.send_bucket_funded_emails(bucket: )
    UserMailer.notify_author_that_bucket_is_funded(bucket: bucket).deliver_later
    bucket_author = bucket.user
    members = bucket.group.members.reject { |member| member == bucket_author }
    members.each do |member|
      UserMailer.notify_member_that_bucket_is_funded(bucket: bucket, member: member).deliver_later
    end
  end
end