require "rails_helper"

describe "BucketService" do

  def create_bucket_participant(bucket: , subscribed:)
    participant = create(:user, subscribed_to_participant_activity: subscribed)
    create(:membership, member: participant, group: bucket.group)
    create(:comment, bucket: bucket, user: participant)
    participant
  end

  before do
    @bucket_author = bucket.user
    @contribution = create(:contribution, bucket: bucket, amount: bucket.target)
    bucket.update(status: 'funded')
  end

  after do
    ActionMailer::Base.deliveries.clear
  end

  describe "#send_bucket_live_emails(bucket:)" do
    before do
      make_user_group_member
      bucket = create(:live_bucket, user: user, group: group)

      # create member with $100.00, who has subscribed to participant activity + has commented on bucket
      @subscribed_participant_with_balance = create_bucket_participant(bucket: bucket, subscribed: true)
      create(:allocation, group: group, amount: 100, user: @subscribed_participant_with_balance)

      # create member without balance, who has subscribed to participant activity + has commented on bucket
      @subscribed_participant_without_balance = create_bucket_participant(bucket: bucket, subscribed: true)

      # bucket creator comments on their bucket
      create(:comment, bucket: bucket, user: user)

      # create bucket participant not subscribed to participant activity
      @unsubscribed_participant = create_bucket_participant(bucket: bucket, subscribed: false)

      # create non participant
      @non_participant = create(:user)
      create(:membership, group: group, member: @non_participant)

      BucketService.send_bucket_live_emails(bucket: bucket)
      @emails = ActionMailer::Base.deliveries
      @email_recipients = @emails.map { |e| e.to.first }
    end

    it "sends emails to all bucket participants subscribed to participant activity, except creator" do
      expect(@emails.length).to eq(2)
      expect(@email_recipients).not_to include(user.email)
      expect(@email_recipients).not_to include(@unsubscribed_participant.email)
      expect(@email_recipients).not_to include(@non_participant.email)
    end

    it "members with funds get an email with their balance" do
      email = @emails.find { |e| e.to.first ==  @subscribed_participant_with_balance.email }
      expect(email.body).to include("$100")
    end

    it "members without funds get an email that does not contain their balance" do
      email = @emails.find { |e| e.to.first ==  @subscribed_participant_without_balance.email }
      expect(email.body).not_to include("$0")
    end
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
