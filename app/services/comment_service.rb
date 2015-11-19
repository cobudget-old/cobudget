class CommentService
  def self.send_new_comment_emails(comment: )
    bucket = comment.bucket
    bucket_author = bucket.user
    comment_author = comment.user

    
    if bucket_author.is_member_of?(bucket.group) && bucket_author != comment_author && bucket_author.subscribed_to_personal_activity
      UserMailer.notify_author_of_new_comment_email(comment: comment).deliver_later
    end

    commenters = User.joins(:comments).where(comments: {bucket_id: bucket.id}).uniq

    funders =  User.joins(:contributions).where(contributions: {bucket_id: bucket.id}).uniq

    # TODO: need to add .active filter to memberships here later
    # users_to_notify = (commenters + funders).uniq.reject { |member| member == comment_author || member == bucket_author }
    # users_to_notify.each { |user| UserMailer.notify_user_of_new_comment_email(comment: comment, user: user).deliver_later } 
  end
end