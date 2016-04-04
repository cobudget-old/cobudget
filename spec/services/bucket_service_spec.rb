require "rails_helper"

describe "BucketService" do
  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#send_bucket_funded_emails" do
    before do
      make_user_group_member
      @bucket = create(:bucket, user: user, group: group, status: "funded")
      @bucket_author = @bucket.user

      # create member with $100.00, who has subscribed to participant activity + has commented on bucket
      @subscribed_participant = create_bucket_participant(bucket: @bucket, subscribed: true)

      # bucket creator comments on their bucket
      create(:comment, bucket: @bucket, user: @bucket_author)

      # create bucket participant not subscribed to participant activity
      @unsubscribed_participant = create_bucket_participant(bucket: @bucket, subscribed: false)

      # create subscribed non participant
      @subscribed_non_participant = create(:user, subscribed_to_participant_activity: true)
      create(:membership, group: group, member: @subscribed_non_participant)

      # create an archived participant
      @archived_participant = create_bucket_participant(bucket: @bucket, subscribed: true)
      Membership.find_by(group: @bucket.group, member: @archived_participant).update(archived_at: DateTime.now.utc - 5.days)
    end

    it "sends 'notify_member_that_bucket_is_funded' emails to all subscribed, participants with active memberships in the group, except author" do
      # temporarily stub out emails sent to author for this set of specs
      mail_double = double(:mail)
      allow(UserMailer).to receive(:notify_author_that_bucket_is_funded).and_return(mail_double)
      allow(mail_double).to receive(:deliver_later).and_return(nil)

      BucketService.send_bucket_funded_emails(bucket: @bucket)
      @email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }

      expect(@email_recipients.length).to eq(1)
      expect(@email_recipients).to include(@subscribed_participant.email)

      expect(@email_recipients).not_to include(@bucket_author.email)
      expect(@email_recipients).not_to include(@unsubscribed_participant.email)
      expect(@email_recipients).not_to include(@subscribed_non_participant.email)
      expect(@email_recipients).not_to include(@archived_participant.email)
    end

    context "bucket author subscribed to personal activity" do
      it "bucket author receives notification email" do
        @bucket_author.update(subscribed_to_personal_activity: true)
        BucketService.send_bucket_funded_emails(bucket: @bucket)
        emails_to_author = ActionMailer::Base.deliveries.select { |e| e.to.first == @bucket_author.email }
        expect(emails_to_author.length).to eq(1)
      end
    end

    context "bucket author not subscribed to personal activity" do
      it "bucket author does not receive notification email" do
        @bucket_author.update(subscribed_to_personal_activity: false)
        BucketService.send_bucket_funded_emails(bucket: @bucket)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).not_to include(@bucket_author.email)
      end
    end
  end

  describe "#send_bucket_created_emails(bucket:)" do
    it "sends emails to all active group members, except creator" do
      make_user_group_member
      bucket = create(:bucket, user: user, group: group, status: "draft")
      create_list(:membership, 5, group: group)
      create_list(:archived_membership, 2, group: group)
      BucketService.send_bucket_created_emails(bucket: bucket)
      email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
      expect(email_recipients.length).to eq(5)
      expect(email_recipients).not_to include(user.email)
    end
  end
end
