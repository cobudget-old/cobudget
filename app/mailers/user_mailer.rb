class UserMailer < ActionMailer::Base
  def invite_email(user: , group:, inviter:)
    @user = user
    @group = group
    @inviter = inviter
    mail(to: @user.name_and_email,
        from: "Cobudget Accounts <accounts@cobudget.co>",
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end

  def invite_to_group_email(user: , inviter: , group: )
    @user = user
    @inviter = inviter
    @group = group
    mail(to: @user.name_and_email,
        from: "Cobudget Accounts <accounts@cobudget.co>",
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end

  def notify_author_of_new_comment_email(comment: )
    @comment = comment
    @bucket = @comment.bucket
    @author = @bucket.user
    @commenter = @comment.user
    @group = @bucket.group
    mail(to: @author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@commenter.name} has commented on your bucket.")
  end

  def notify_user_of_new_comment_email(comment: , user:)
    @comment = comment
    @bucket = @comment.bucket
    @commenter = @comment.user
    @group = @bucket.group
    mail(to: user.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@commenter.name} has commented on #{@bucket.name}")
  end

  def notify_author_that_bucket_received_contribution(contribution: )
    @contribution = contribution
    @bucket = contribution.bucket
    @funder = contribution.user
    @group = @bucket.group
    author = @bucket.user
    mail(to: author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@funder.name} has funded your bucket - #{@contribution.formatted_amount}.")
  end

  def notify_author_that_bucket_is_funded(bucket: )
    @bucket = bucket
    @group = @bucket.group
    @author = @bucket.user
    mail(to: @author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] Your bucket has been fully funded!")
  end

  def notify_member_with_balance_that_bucket_is_live(bucket: , member: )
    @bucket = bucket
    @group = @bucket.group
    @membership = Membership.find_by(member: member, group: @group)
    mail(to: member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@bucket.name} is now requesting funding!")
  end

  def notify_member_with_zero_balance_that_bucket_is_live(bucket: , member: )
    @bucket = bucket
    @group = @bucket.group
    @membership = Membership.find_by(member: member, group: @group)
    mail(to: member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "[Cobudget - #{@group.name}] #{@bucket.name} is now requesting funding!")
  end

  def notify_member_that_bucket_is_funded(bucket: , member: )
    @bucket = bucket
    @group = @bucket.group
    @member_contribution_amount = Contribution.where(bucket: bucket, user: member).sum(:amount)
    @formatted_member_contribution_amount = Money.new(@member_contribution_amount * 100, "USD").format
    if @member_contribution_amount > 0
      mail(to: member.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "[Cobudget - #{@group.name}] You did it! #{@bucket.name} has been fully funded!")
    else 
      mail(to: member.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "[Cobudget - #{@group.name}] #{@bucket.name} has been fully funded!")      
    end
  end
end