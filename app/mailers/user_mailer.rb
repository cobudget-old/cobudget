class UserMailer < ActionMailer::Base
  def invite_email(user: , group: , inviter: , initial_allocation_amount:)
    @user = user
    @group = group
    @inviter = inviter
    @initial_allocation_amount = initial_allocation_amount
    @initial_allocation_amount_formatted = Money.new(initial_allocation_amount * 100, @group.currency_code).format
    mail(to: @user.name_and_email,
        from: "Cobudget Accounts <accounts@cobudget.co>",
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end

  def invite_to_group_email(user: , inviter: , group: , initial_allocation_amount:)
    @user = user
    @inviter = inviter
    @group = group
    @initial_allocation_amount = initial_allocation_amount
    @initial_allocation_amount_formatted = Money.new(initial_allocation_amount * 100, @group.currency_code).format
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
         subject: "#{@commenter.name} has commented on your bucket.")
  end

  def notify_user_of_new_comment_email(comment: , user:)
    @comment = comment
    @bucket = @comment.bucket
    @commenter = @comment.user
    @group = @bucket.group
    mail(to: user.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@commenter.name} has commented on #{@bucket.name}")
  end

  def notify_author_that_bucket_received_contribution(contribution: )
    @contribution = contribution
    @bucket = contribution.bucket
    @funder = contribution.user
    @group = @bucket.group
    author = @bucket.user
    mail(to: author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@funder.name} has funded your bucket - #{@contribution.formatted_amount}.")
  end

  def notify_author_that_bucket_is_funded(bucket: )
    @bucket = bucket
    @group = @bucket.group
    @author = @bucket.user
    mail(to: @author.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "Your bucket has been fully funded!")
  end

  def notify_member_with_balance_that_bucket_is_live(bucket: , member: )
    @bucket = bucket
    @group = @bucket.group
    @membership = Membership.find_by(member: member, group: @group)
    mail(to: member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@bucket.name} is now requesting funding!")
  end

  def notify_member_with_zero_balance_that_bucket_is_live(bucket: , member: )
    @bucket = bucket
    @group = @bucket.group
    @membership = Membership.find_by(member: member, group: @group)
    mail(to: member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@bucket.name} is now requesting funding!")
  end

  def notify_member_that_bucket_is_funded(bucket: , member: )
    @bucket = bucket
    @group = @bucket.group
    @member_contribution_amount = Contribution.where(bucket: bucket, user: member).sum(:amount)
    @formatted_member_contribution_amount = Money.new(@member_contribution_amount * 100, @group.currency_code).format
    if @member_contribution_amount > 0
      mail(to: member.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "You did it! #{@bucket.name} has been fully funded!")
    else 
      mail(to: member.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "#{@bucket.name} has been fully funded!")      
    end
  end

  def notify_member_that_bucket_was_created(bucket: , member:)
    @bucket = bucket
    mail(to: member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{bucket.user.name} has created a new bucket idea: #{@bucket.name}")      
  end

  def notify_member_that_they_received_allocation(admin: , member: , group: , amount:)
    @member = member
    @group = group
    @formatted_amount = Money.new(amount * 100, @group.currency_code).format
    mail(to: @member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{admin.name} gave you funds to spend in #{@group.name}")
  end

  def invite_new_group_email(user: , inviter:)
    @user = user
    @inviter = inviter
    @redirect_url = "#{root_url}#/confirm_account?confirmation_token=#{@user.confirmation_token}&create_group=true".html_safe
    mail(to: @user.name_and_email,
         from: "Cobudget Accounts <accounts@cobudget.co>",
         subject: "#{inviter.name} invited you to create a new group on Cobudget")
  end

  def notify_funder_that_bucket_was_deleted(funder: , bucket: )
    @bucket = bucket
    @group = @bucket.group
    refund_amount = @bucket.contributions.where(user: funder).sum(:amount)
    @formatted_refund_amount = Money.new(refund_amount * 100, @group.currency_code).format
    mail(to: funder.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@bucket.name} was deleted")
  end

  def reset_password_email(user:)
    @user = user
    subject = @user.has_set_up_account? ? "Reset Password Instructions" : "Set up your Cobudget Account"
    mail(to: user.name_and_email,
         from: "Cobudget Accounts <accounts@cobudget.co>",
         subject: subject)
  end

  def daily_email_digest(user: , recent_activity:)
    @user = user 
    @recent_activity = recent_activity
    mail(to: user.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "its an email digest")
  end
end