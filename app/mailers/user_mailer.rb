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

  def invite_to_group_email(user, inviter, group, round)
    @user = user
    @inviter = inviter
    @group = group
    @round = round
    mail(to: user.name_and_email,
        from: inviter.name_and_email,
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end
end