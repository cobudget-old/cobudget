class CommentService
  def self.send_new_comment_emails(comment: )
    bucket = comment.bucket
    bucket_author = bucket.user
    comment_author = comment.user
    UserMailer.notify_author_of_new_comment_email(comment: comment).deliver_later unless bucket_author == comment_author

    commenters = bucket.comments.map { |comment| comment.user }
    funders = bucket.contributions.map { |contribution| contribution.user }
    users_to_notify = (commenters + funders).uniq { |member| member.id }.reject { |member| member == comment_author || member == bucket_author }
    users_to_notify.each { |user| UserMailer.notify_user_of_new_comment_email(comment: comment, user: user).deliver_later } 
  end
end