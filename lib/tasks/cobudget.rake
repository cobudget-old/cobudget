namespace :cobudget do
  desc "delivers recent activity digest emails to users"
  task deliver_recent_activity_emails: :environment do
    DeliverRecentActivityEmails.to_email_notification_subscribers!
    DeliverRecentActivityEmails.to_daily_digest_subscribers!
    DeliverRecentActivityEmails.to_weekly_digest_subscribers!
    DeliverCheckTransactionsEmail.check_transactions!
  end
end
