require 'csv'

class MembershipService
  def self.archive_membership(membership: )
    member = membership.member
    group = membership.group

    # archives member's draft + live buckets
    Bucket.where(group: group.id, user: member.id).where.not(status: "funded").find_each do |bucket|
      BucketService.archive(bucket: bucket, exclude_author_from_email_notifications: true)
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
        csv << [membership.member.email, membership.raw_balance.to_f, membership.member.updated_at.strftime("%b %-d %Y")]
      end
    end
  end

  def self.generate_admin_csv(memberships:)
    CSV.generate do |csv|
      memberships.each do |membership|
        csv << [membership.member.email, membership.member.name, membership.group.name]
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
        email = row[0].downcase
        errors << "malformed email address: #{email}" unless /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.match(email)
      end
    end
    errors if errors.any?
  end

  def self.generate_csv_upload_preview(csv:, group:)
    csv.uniq { |row| row[0] }.map do |row|
      email = row[0].downcase
      user = User.find_by_email(email)
      {
        id: user && user.is_member_of?(group) ? user.id : "",
        email: email,
        name: user && user.is_member_of?(group) ? user.name : "",
        new_member: !user || !user.is_member_of?(group)
      }
    end
  end

  def self.check_all_memberships
    error_memberships = []
    count = 0
    Membership.with_totals.find_each do |membership|
      count += 1
      if !membership.transactions_data_ok?
        error_memberships.push(bucket.id)
      end
    end
    if error_memberships.length == 0
      puts %(Checked #{count} memberships. No errors found.)
    else
      puts %(Checked #{count} memberships. Errors found in #{error_memberships})
    end
  end
end
