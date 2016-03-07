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
        id: user && user.is_member_of?(group) ? user.id : "",
        email: email,
        name: user && user.is_member_of?(group) ? user.name : "",
        allocation_amount: allocation_amount,
        new_member: !user || !user.is_member_of?(group)
      }
    end
  end

  private
    def self.is_number?(string)
      true if Float(string) rescue false
    end
end
