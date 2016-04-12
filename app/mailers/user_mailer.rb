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

  def recent_personal_activity_email(user:, time_range:)
    @user = user
    @recent_activity = RecentActivityService.new(user: user, time_range: time_range)
    formatted_date = time_range.first.strftime("%I:%M %p (%B %d, %Y)")
    if @recent_activity.personal_activity_present?
      mail(to: user.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "Activity in your Cobudget groups since #{formatted_date}"
      )
    end
  end

  def recent_activity_digest_email(user:, time_range:)
    @user = user
    @recent_activity = RecentActivityService.new(user: user, time_range: time_range)
    formatted_date = time_range.first.strftime("%B %d, %Y")
    subject =
      if user.subscription_tracker.email_digest_delivery_frequency == "daily"
        "Yesterday's activity in your Cobudget groups (#{formatted_date})"
      end
    if @recent_activity.is_present?
      mail(to: user.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: subject
      )
    end
  end
end
