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

  def join_cobudget_and_create_group_invite(user: , inviter:)
    @user = user
    @inviter = inviter
    @redirect_url = "#{root_url}#/confirm_account?confirmation_token=#{@user.confirmation_token}&setup_group=true".html_safe
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
    subject = @user.confirmed? ? "Reset Password Instructions" : "Set up your Cobudget Account"
    mail(to: user.name_and_email,
         from: "Cobudget Accounts <accounts@cobudget.co>",
         subject: subject)
  end

  def daily_email_digest(user:)
    @user = user
    @formatted_date_today = DateTime.now.in_time_zone(user.utc_offset / 60).strftime("%A, %B %d")
    if @recent_activity = UserService.fetch_recent_activity_for(user: user)
      mail(to: user.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "[Cobudget] Daily Summary - New activity in your groups")
    end
  end

  def confirm_account_email(user:)
    @user = user
    mail(to: user.name_and_email,
         from: "Cobudget Accounts <accounts@cobudget.co>",
         subject: "Time to set up your account!"
    )
  end

  def recent_activity(user:, recent_activity:)
    @user = user
    @recent_activity = recent_activity
    @last_fetched_at = @user.subscription_tracker.last_fetched_at_formatted
    mail(to: user.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "My recent activity on Cobudget - from #{@last_fetched_at}"
    )
  end
end
