class AllocationService
  def self.create_allocations_from_csv(csv: , group: )
    csv.each do |email, amount|
      email = email.downcase.strip

      unless user = User.find_by_email(email)
        tmp_name = email[/[^@]+/]
        user = User.create(email: email, name: tmp_name, password: "password")
      end

      unless group.members.find_by_id(user.id)
        group.members << user 
      end

      Allocation.create(group: group, user: user, amount: amount)
    end
  end
end