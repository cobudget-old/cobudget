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
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@commenter.name} has commented on your project.")
  end

  def notify_user_of_new_comment_email(comment: , user:)
    @comment = comment
    @project = @comment.bucket
    @commenter = @comment.user
    @group = @project.group
    mail(to: user.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@commenter.name} has commented on #{@project.name}")
  end

  def notify_author_that_project_received_contribution(contribution: )
    @contribution = contribution
    @project = contribution.bucket
    @funder = contribution.user
    @group = @project.group
    author = @project.user
    mail(to: author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@funder.name} has funded your project - #{@contribution.formatted_amount}.")
  end

  def notify_author_that_project_is_funded(project: )
    @project = project
    @group = @project.group
    @author = @project.user
    mail(to: @author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] Your project has been fully funded!")
  end

  def notify_member_that_project_is_live(project: , member: )
    @project = project
    @group = @project.group
    @membership = Membership.find_by(member: member, group: @group)
    mail(to: member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@project.name} is now requesting funding!")
  end

  def notify_funder_that_project_is_funded(project: , funder: )
    @project = project
    @group = @project.group
    funder_contributions = Contribution.where(bucket: project, user: funder)
    @funder_contribution_amount = Money.new(funder_contributions.sum(:amount) * 100, "USD").format
    mail(to: funder.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] You did it! #{@project.name} has been fully funded!")
  end
end