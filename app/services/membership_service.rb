require 'csv'

class MembershipService
  def self.archive_membership(membership: )
    member = membership.member
    group = membership.group

    # destroy member's draft buckets
    Bucket.where(group: group.id, user: member.id, status: 'draft').destroy_all

    # destroy member's funding buckets, refund all their funders, and notify funders of refund via email
    Bucket.where(user_id: member.id, status: 'live', group_id: group.id).each do |bucket|
      funders = bucket.contributors(exclude_author: true)
      funders.each do |funder|
        UserMailer.notify_funder_that_bucket_was_deleted(funder: funder, bucket: bucket).deliver_now
      end
      bucket.destroy
    end

    # destroy member's contributions on funding buckets
    Contribution.joins(:bucket).where(user_id: member.id, buckets: {group_id: group.id, status: 'live'}).destroy_all

    # remove member's funds from group (by creating a negative allocation equal to the member's balance)
    Allocation.create(user: member, group: group, amount: -membership.balance)

    # archive membership
    membership.archive!
  end

  def self.generate_csv(memberships:)
    CSV.generate do |csv|
      memberships.each do |membership|
        csv << [membership.member.email, membership.balance.to_f]
      end
    end
  end

  def self.check_csv_for_errors(csv: )
    errors = []
    if csv.nil? || csv.empty?
      errors << "csv is empty"
    else
      errors << "too many columns" if csv.first.length > 1
      csv.each_with_index do |row, index|
        email = row[0]
        errors << "malformed email address: #{email}" unless /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.match(email)
      end
    end
    errors if errors.any?
  end

  def self.generate_csv_upload_preview(csv:, group:)
    csv.map do |row|
      email = row[0]
      user = User.find_by_email(email)
      {
        id: user && user.is_member_of?(group) ? user.id : "",
        email: email,
        name: user && user.is_member_of?(group) ? user.name : "",
        new_member: !user || !user.is_member_of?(group)
      }
    end
  end
end
