class BucketService
  # given current email settings - might remove in future? 
  def self.send_bucket_created_emails(bucket: , current_user:)
    members = bucket.group.members.where.not(id: current_user.id)
    members.each do |member|
      UserMailer.notify_member_that_bucket_was_created(bucket: bucket, member: member).deliver_later
    end
  end

  def self.send_bucket_live_emails(bucket: )
    memberships = Membership.joins(:member)
                            .where(group_id: bucket.group.id)
                            .where.not(users: {id: bucket.user.id})
                            .where(users: {subscribed_to_participant_activity: true})
    memberships.each do |membership|
      member = membership.member
      if membership.balance > 0
        UserMailer.notify_member_with_balance_that_bucket_is_live(bucket: bucket, member: member).deliver_later
      else
        UserMailer.notify_member_with_zero_balance_that_bucket_is_live(bucket: bucket, member: member).deliver_later
      end
    end
  end

  def self.send_bucket_funded_emails(bucket: )
    bucket_author = bucket.user
    if bucket_author && bucket_author.subscribed_to_personal_activity
      UserMailer.notify_author_that_bucket_is_funded(bucket: bucket).deliver_later
    end
    members = bucket.group.members
                    .where.not(id: bucket_author.id)
                    .where(subscribed_to_participant_activity: true)
    members.each do |member|
      UserMailer.notify_member_that_bucket_is_funded(bucket: bucket, member: member).deliver_later
    end
  end
end