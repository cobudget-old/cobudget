class UserMailer < ActionMailer::Base
  def invite_email(user, inviter, group, tmp_password)
    @user = user
    @inviter = inviter
    @tmp_password = tmp_password
    @group = group
    mail(to: user.name_and_email,
        from: inviter.name_and_email,
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end

  def invite_to_group_email(user, inviter, group)
    @user = user
    @inviter = inviter
    @group = group
    mail(to: user.name_and_email,
        from: inviter.name_and_email,
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end

  def invite_to_propose_email(user, inviter, round)
    @user = user
    @group = round.group
    @round = round
    mail(to: user.name_and_email,
        from: inviter.name_and_email,
        subject: "Propose Projects for Funding in Cobudget")
  end

  def invite_to_contribute_email(user, inviter, round)
    @user = user
    @group = round.group
    @round = round
    @allocation_amount = round.allocations.find_by(user_id: user.id).formatted_amount
    mail(to: user.name_and_email,
        from: inviter.name_and_email,
        subject: "You have #{@allocation_amount} - Fund projects now in Cobudget!")
  end

  def round_closed_email(user, sender, round)
    @group = round.group
    @round = round
    mail(to: user.name_and_email,
        from: sender.name_and_email,
        subject: "#{round.name} in #{@group.name} has closed!")
  end
end