require 'rails_helper'

xdescribe "Comments" do
  describe "POST '/comments'" do
    it "creates a new comment" do
    end

    it "returns the comment in an array" do
    end

    it "sends a 'notify_author_of_new_comment_email' to the author" do
    end

    it "sends a 'notify_user_of_new_comment_email' to all funders of and commenters on the bucket" do
    end

    it "does not send a 'notify_user_of_new_comment_email' to the commenter" do
    end

    context "the commenter is also the author of the bucket" do
      it "no emails are sent to the commenter" do
      end      
    end
  end
end