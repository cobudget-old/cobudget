require "rails_helper"

describe "ContributionService" do
  before do
    @bucket_author = bucket.user
    @contribution = create(:contribution, bucket: bucket)
    @funder = @contribution.user
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "send_bucket_received_contribution_emails" do
    context "bucket author subscribed to personal activity" do
      it "bucket author receives notification email" do
        @bucket_author.update(subscribed_to_personal_activity: true)
        ContributionService.send_bucket_received_contribution_emails(contribution: @contribution)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).to include(@bucket_author.email)
      end
    end

    context "bucket author not subscribed to personal activity" do
      it "bucket author does not receive notification email" do
        @bucket_author.update(subscribed_to_personal_activity: false)
        ContributionService.send_bucket_received_contribution_emails(contribution: @contribution)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).not_to include(@bucket_author.email)
      end
    end
  end
end
