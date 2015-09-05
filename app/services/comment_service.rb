class CommentService
  def self.send_new_comment_emails(comment: )
    UserMailer.notify_author_of_new_comment_email(comment: comment).deliver_later
  end
end