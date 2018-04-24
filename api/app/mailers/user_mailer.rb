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

  def invite_email_reminder(user: , group: , inviter: , initial_allocation_amount:)
    @user = user
    @group = group
    @inviter = inviter
    @initial_allocation_amount = initial_allocation_amount.floor
    @initial_allocation_amount_formatted = Money.new(initial_allocation_amount * 100, @group.currency_code).format
    if !@user.confirmed_at?
      mail(to: @user.name_and_email,
          from: "Cobudget Accounts <accounts@cobudget.co>",
          subject: "Your invitation to Cobudget is waiting")
    end
  end

  def notify_member_that_they_received_allocation(admin: , member: , group: , amount:)
    @member = member
    @group = group
    @formatted_amount = Money.new(amount * 100, @group.currency_code).format
    mail(to: @member.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{admin.name} gave you funds to spend in #{@group.name}")
  end

  def notify_funder_that_bucket_was_archived(funder: , bucket:, refund_amount: )
    @bucket = bucket
    @group = @bucket.group
    @formatted_refund_amount = Money.new(refund_amount * 100, @group.currency_code).format
    action = bucket.archived? ? "cancelled" : "deleted"
    mail(to: funder.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@bucket.name} was #{action}")
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

  def recent_personal_activity_email(user:)
    @user = user
    current_hour_utc = DateTime.now.utc.beginning_of_hour
    time_range = (current_hour_utc - 1.hour)..current_hour_utc
    @recent_activity = RecentActivityService.new(user: user, time_range: time_range)
    formatted_date = time_range.first.in_time_zone((user.utc_offset || 0) / 60).strftime("%I:%M %p (%B %d, %Y)")
    if @recent_activity.personal_activity_present?
      mail(to: user.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "Activity in your Cobudget groups since #{formatted_date}"
      )
    end
  end

  def recent_activity_digest_email(user:)
    @user = user
    current_hour_utc = DateTime.now.utc.beginning_of_hour
    if @user.subscription_tracker.email_digest_delivery_frequency == "daily"
      time_range = (current_hour_utc - 1.day)..current_hour_utc
      @formatted_time_period = "yesterday"
    else
      time_range = (current_hour_utc - 1.week)..current_hour_utc
      @formatted_time_period = "last week"
    end

    @recent_activity = RecentActivityService.new(user: user, time_range: time_range)
    formatted_date = time_range.first.in_time_zone((user.utc_offset || 0) / 60).strftime("%B %d, %Y")

    if @recent_activity.is_present?
      mail(to: user.name_and_email,
           from: "Cobudget Updates <updates@cobudget.co>",
           subject: "Activity in your Cobudget groups from #{@formatted_time_period} (#{formatted_date})"
      )
    end
  end

  def notify_admins_funds_are_returned_to_group_account(admin:, bucket:, done_by:, archived_member:, amount:)
    @bucket = bucket
    @group = bucket.group
    @done_by = done_by
    @archived_member = archived_member
    @amount = amount
    @formatted_amount = Money.new(amount * 100, @group.currency_code).format
    mail(to: admin.name_and_email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "Funds from cancelled bucket have been returned to group account")
  end

  def notify_admins_archived_member_funds(admin: , group: ,memberlist: )
    @memberlist = memberlist
    @group = group
    @group_user = group.ensure_group_user_exist()
    mail(to: admin,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "Funds from archived members is returned to group account")
  end

  def check_transactions_email
    if Rails.configuration.respond_to?('devops_user')
      mail(to: Rails.configuration.devops_user,
        from: "Cobudget Updates <updates@cobudget.co>",
        subject: "DB transactions consistency check")
    end
  end

  def notify_member_that_they_were_mentioned(author:, member:, bucket:, body:)
    @bucket = bucket
    @group = bucket.group
    @body = body
    @author = author
    mail(to: member.email,
         from: "Cobudget Updates <updates@cobudget.co>",
         subject: "#{@author.name} mentioned you in the bucket #{@bucket.name}")
  end
end
