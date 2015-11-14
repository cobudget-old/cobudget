class MembershipService
  def self.archive_membership(membership: )
    member = membership.member
    group = membership.group

    # destroy member's draft buckets
    Bucket.where(group: group.id, user: member.id, status: 'draft').destroy_all

    # destroy member's funding buckets, refund all their funders, and notify funders of refund via email
    Bucket.where(user_id: member.id, status: 'live', group_id: group.id).each do |bucket|
      contributions = bucket.contributions
      funders = contributions.map { |c| c.user }.uniq
      funders.each do |funder|
        UserMailer.notify_funder_that_bucket_was_deleted(funder: funder, bucket: bucket).deliver_now
      end
      contributions.destroy_all
      bucket.destroy
    end

    # destroy member's contributions on funding buckets
    Contribution.joins(:bucket).where(user_id: member.id, buckets: {group_id: group.id, status: 'live'}).destroy_all

    # remove member's funds from group (by creating a negative allocation equal to the member's balance)
    Allocation.create(user: member, group: group, amount: -membership.balance)

    # archive membership
    membership.update(archived_at: DateTime.now.utc)
  end
end