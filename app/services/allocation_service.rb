class AllocationService
  def self.create_allocations_from_csv(csv: , group: , current_user:)
    csv.each do |email, amount|
      email = email.downcase.strip
      amount = amount.to_s.gsub(",", "").to_f

      if user = User.find_by_email(email)
        if user.is_member_of?(group)
          UserMailer.notify_member_that_they_received_allocation(admin: current_user, member: user, group: group, amount: amount).deliver_later if amount > 0
        else
          group.members << user
          UserMailer.invite_to_group_email(user: user, inviter: current_user, group: group, initial_allocation_amount: amount).deliver_later
        end
      else
        user = User.create_with_confirmation_token(email: email)
        group.members << user
        UserMailer.invite_email(user: user, group: group, inviter: current_user, initial_allocation_amount: amount).deliver_later if user.valid?
      end

      Allocation.create(group: group, user: user, amount: amount)
    end
  end
end
