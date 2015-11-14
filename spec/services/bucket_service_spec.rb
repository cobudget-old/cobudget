require "rails_helper"

describe "BucketService" do
  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#send_bucket_funded_emails" do
    before do
      @bucket_author = bucket.user
      @contribution = create(:contribution, bucket: bucket, amount: bucket.target)
      bucket.update(status: 'funded')
    end

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

  describe "#send_bucket_created_emails" do
    it "sends emails to all active group members, except creator" do
      make_user_group_member
      bucket = create(:draft_bucket, user: user, group: group)
      create_list(:membership, 5, group: group)
      create_list(:archived_membership, 2, group: group)
      BucketService.send_bucket_created_emails(bucket: bucket)
      email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
      expect(email_recipients.length).to eq(5)
      expect(email_recipients).not_to include(user.email)      
    end
  end
end
