namespace :cobudget do
  desc "delivers daily email digest to users with recent activity whose local time is between 6AM - 7AM"
  task deliver_daily_email_digest: :environment do
    DeliverDailyEmailDigest.to_subscribers!
  end
end
