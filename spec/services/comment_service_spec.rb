require "rails_helper"

describe "CommentService" do
  describe "#send_new_comment_emails(comment: )" do
    before do
      @membership = make_user_group_member
      @bucket = create(:bucket, group: group, user: user)
      @bucket_author = user
      @comment = create(:comment, bucket: @bucket)
      @comment_author = @comment.user
    end

    after do 
      ActionMailer::Base.deliveries.clear
    end

    context "bucket author subscribed to personal activity" do
      it "bucket author receives notification email" do
        CommentService.send_new_comment_emails(comment: @comment)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).to include(@bucket_author.email)
      end
    end

    context "bucket author not subscribed to personal activity" do
      it "bucket author does not receive notification email" do
        @bucket_author.update(subscribed_to_personal_activity: false)
        CommentService.send_new_comment_emails(comment: @comment)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).not_to include(@bucket_author.email)
      end
    end

    context "bucket author no longer member of group" do
      it "bucket author does not receive notification email" do
        @membership.update(archived_at: DateTime.now.utc - 5.days)
        CommentService.send_new_comment_emails(comment: @comment)
        email_recipients = ActionMailer::Base.deliveries.map { |e| e.to.first }
        expect(email_recipients).not_to include(@bucket_author.email)
      end      
    end
  end
end
