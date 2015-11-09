require "rails_helper"

describe "BucketService" do
  before do
    @bucket_author = bucket.user
    @contribution = create(:contribution, bucket: bucket, amount: bucket.target)
    bucket.update(status: 'funded')
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#send_bucket_funded_emails" do
    context "bucket author subscribed to personal activity" do
      it "bucket author receives notification email" do
        @bucket_author.update(subscribed_to_personal_activity: true)
        BucketService.send_bucket_funded_emails(bucket: bucket)
        emails_to_author = ActionMailer::Base.deliveries.select { |e| e.to.first == @bucket_author.email }
        expect(emails_to_author.length).to eq(1)
      end
    end

    context "bucket author not subscribed to personal activity" do
      it "bucket author does not receive notification email" do
        @bucket_author.update(subscribed_to_personal_activity: false)
        BucketService.send_bucket_funded_emails(bucket: bucket)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).not_to include(@bucket_author.email)
      end
    end
  end
end
