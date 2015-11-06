namespace :cobudget do
  task deliver_daily_email_digest: :environment do
    DeliverDailyEmailDigest.to_subscribers!
  end
end
