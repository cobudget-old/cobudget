class AllocationService
  def self.create_allocations_from_csv(csv: , group: , current_user:)
    csv.each do |email, amount|
      email = email.downcase.strip
      user = User.find_by_email(email)

      if user && !group.members.find_by_id(user.id)
        group.members << user
        UserMailer.invite_to_group_email(user: user, inviter: current_user, group: group).deliver_later
      elsif !user
        user = User.create_with_confirmation_token(email: email)
        group.members << user
        UserMailer.invite_email(user: user, group: group, inviter: current_user).deliver_later if user.valid?
      end

      Allocation.create(group: group, user: user, amount: amount)
    end
  end
end