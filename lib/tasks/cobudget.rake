namespace :cobudget do
  desc "delivers recent activity digest emails to users"
  task deliver_recent_activity_digest: :environment do
    DeliverRecentActivityDigest.run!
  end
end
