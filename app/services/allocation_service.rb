class AllocationService
  def self.check_csv_for_errors(csv: )
    errors = []
    if csv.nil? || csv.empty?
      errors << "csv is empty"
    else
      errors << "too many columns" if csv.first.length > 2
      csv.each_with_index do |row, index|
        email = row[0]
        allocation_amount = row[1]
        errors << "malformed email address: #{email}" unless /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/.match(email)
        errors << "non-number allocation amount '#{allocation_amount}' for email: #{email}" unless is_number?(allocation_amount)
      end
    end
    errors if errors.any?
  end

  def self.generate_csv_upload_preview(csv:, group:)
    csv.map do |row|
      email = row[0]
      allocation_amount = row[1]
      user = User.find_by_email(email)
      {
        email: email,
        name: user && user.is_member_of?(group) ? user.name : "",
        allocation_amount: allocation_amount,
        new_member: !user || !user.is_member_of?(group)
      }
    end
  end

  def self.create_allocations_from_csv(parsed_csv: , group: , current_user:)
    upload_success = true
    emails = []

    ActiveRecord::Base.transaction do
      begin
        parsed_csv.each do |email, amount|
          email = email.downcase.strip
          amount = amount.to_s.gsub(",", "").to_f

          if user = User.find_by_email(email)
            if membership = user.membership_for(group)
              if membership.archived?
                membership.reactivate!
                emails << UserMailer.invite_to_group_email(user: user, inviter: current_user, group: group, initial_allocation_amount: amount)
              else
                emails << UserMailer.notify_member_that_they_received_allocation(admin: current_user, member: user, group: group, amount: amount) if amount >= 1
              end
            else
              group.add_member(user)
              emails << UserMailer.invite_to_group_email(user: user, inviter: current_user, group: group, initial_allocation_amount: amount)
            end
          else
            user = User.create_with_confirmation_token(email: email)
            group.add_member(user)
            emails << UserMailer.invite_email(user: user, group: group, inviter: current_user, initial_allocation_amount: amount) if user.valid?
          end

          Allocation.create(group: group, user: user, amount: amount)
        end
      rescue
        upload_success = false
      end
      if upload_success
        emails.each { |email| email.deliver_later }
      else
        raise ActiveRecord::Rollback unless upload_success
      end
    end
    upload_success
  end

  private
    def self.is_number?(string)
      true if Float(string) rescue false
    end
end
