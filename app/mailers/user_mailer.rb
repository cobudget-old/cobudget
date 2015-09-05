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

  def notify_author_of_new_comment_email(comment: )
    @comment = comment
    @project = @comment.bucket
    @author = @project.user
    @commenter = @comment.user
    @group = @project.group
    mail(to: @author.name_and_email,
         from: "Platonic Mystical Dog <platonic_mystical_dog@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@commenter.name} has commented on your project.")
  end

  def notify_user_of_new_comment_email(comment: , user:)
    @comment = comment
    @project = @comment.bucket
    @commenter = @comment.user
    @group = @project.group
    mail(to: user.name_and_email,
         from: "Platonic Mystical Dog <platonic_mystical_dog@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@commenter.name} has commented on #{@project.name}")
  end

  def notify_author_that_project_received_funding(contribution: )
    @contribution = contribution
    @project = contribution.bucket
    @funder = contribution.user
    @group = @project.group
    author = @project.user
    mail(to: author.name_and_email,
         from: "Platonic Mystical Dog <platonic_mystical_dog@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@funder.name} has funded your project - #{@contribution.formatted_amount}.")
  end
end