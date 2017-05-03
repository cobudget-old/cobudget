class AllocationService
  def self.check_csv_for_errors(csv:, group:)
    errors = []
    if csv.nil? || csv.empty?
      errors << "csv is empty"
    else
      errors << "too many columns" if csv.first.length > 3

      csv.each_with_index do |row, index|
        email = row[0].downcase
        allocation_amount = row[1]
        errors << "malformed email address: #{email}" unless /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.match(email)
        if is_valid_float?(allocation_amount)
          allocation_amount = allocation_amount.to_f
          if allocation_amount_overdrafts_member?(amount: allocation_amount, group: group, email: email)
            membership = membership_for(group: group, email: email)
            balance = membership ? membership.raw_balance : 0
            errors << "allocation amount of #{Money.new(allocation_amount * 100, group.currency_code).format} would overdraft member with email address #{email}, who currently has #{Money.new(balance * 100, group.currency_code).format}"
          end
        else
          errors << "non-number allocation amount '#{allocation_amount}' for email: #{email}"
        end
      end
    end
    errors if errors.any?
  end

  def self.generate_csv_upload_preview(csv:, group:)
    csv.group_by { |row| row[0].downcase }.map do |email, rows|
      allocation_amount = rows.sum { |row| row[1].to_f }
      notify = rows[0][2]
      notify = !!(if notify == 'false' || notify == ' false' then false else true end)
      user = User.find_by_email(email)
      {
        id: user && user.is_member_of?(group) ? user.id : "",
        email: email,
        name: user && user.is_member_of?(group) ? user.name : "",
        allocation_amount: allocation_amount.round(2),
        new_member: !user || !user.is_member_of?(group),
        notify: notify
      }
    end
  end

  private
    def self.is_valid_float?(string)
      true if Float(string) rescue false
    end

    def self.membership_for(group:, email:)
      user = User.find_by_email(email)
      membership = Membership.find_by(member: user, group: group)
      membership if user && membership
    end

    def self.allocation_amount_overdrafts_member?(amount:, group:, email:)
      if membership = membership_for(group: group, email: email)
        membership.raw_balance + amount < 0
      else
        amount < 0
      end
    end
end
