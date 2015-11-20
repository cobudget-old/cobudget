class BucketService
  # given the current email settings, its likely that this will never be called
  def self.send_bucket_created_emails(bucket: )
    memberships = bucket.group.memberships.active.where.not(member_id: bucket.user_id)
    memberships.each do |membership|
      member = membership.member
      UserMailer.notify_member_that_bucket_was_created(bucket: bucket, member: member).deliver_later
    end
  end

  def self.send_bucket_live_emails(bucket: )
    group = bucket.group
    members = bucket.participants(exclude_author: true, subscribed: true)
    members.each do |member|
      membership = member.membership_for(group)
      next if membership.archived?
      if membership.balance > 0
        UserMailer.notify_member_with_balance_that_bucket_is_live(bucket: bucket, member: member).deliver_later
      else
        UserMailer.notify_member_with_zero_balance_that_bucket_is_live(bucket: bucket, member: member).deliver_later
      end
    end
  end

  def self.send_bucket_funded_emails(bucket: )
    group = bucket.group
    bucket_author = bucket.user
    if bucket_author && bucket_author.subscribed_to_personal_activity
      UserMailer.notify_author_that_bucket_is_funded(bucket: bucket).deliver_later
    end

    members = bucket.participants(exclude_author: true, subscribed: true)
    members.each do |member|
      membership = member.membership_for(group)
      next if membership.archived?
      UserMailer.notify_member_that_bucket_is_funded(bucket: bucket, member: member).deliver_later
    end
  end
end