class UserMailer < ActionMailer::Base
  def invite_email(user: , group: , inviter: , initial_allocation_amount:)
    @user = user
    @group = group
    @inviter = inviter
    @initial_allocation_amount = initial_allocation_amount.floor
    @initial_allocation_amount_formatted = Money.new(initial_allocation_amount * 100, @group.currency_code).format
    mail(to: @user.name_and_email,
        from: "Cobudget Accounts <accounts@cobudget.co>",
        subject: "#{inviter.name} invited you to join \"#{group.name}\" on Cobudget")
  end

  def notify_member_that_they_received_allocation(admin: , member: , group: , amount:)
    @member = member
    @group = group
    @formatted_amount = Money.new(amount * 100, @group.currency_code).format
    mail(to: @member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{admin.name} gave you funds to spend in #{@group.name}")
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
    subject = @user.confirmed? ? "Reset Password Instructions" : "Set up your Cobudget Account"
    mail(to: user.name_and_email,
         from: "Cobudget Accounts <accounts@cobudget.co>",
         subject: subject)
  end

  def confirm_account_email(user:)
    @user = user
    mail(to: user.name_and_email,
         from: "Cobudget Accounts <accounts@cobudget.co>",
         subject: "Time to set up your account!"
    )
  end

  def recent_activity_email(user:)
    @user = user
    @recent_activity = RecentActivityService.new(user: user)
    if @recent_activity.is_present?
      @last_fetched_at = @user.subscription_tracker.last_fetched_at_formatted
      mail(to: user.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "My recent activity on Cobudget - from #{@last_fetched_at}"
      )
    end
    user.subscription_tracker.update_next_fetch_time_range!
  end
end
