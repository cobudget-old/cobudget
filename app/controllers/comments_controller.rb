class CommentsController < AuthenticatedController
  before_action :validate_user_is_group_member!

  api :GET, '/comments?bucket_id='
  def index
    bucket = Bucket.find(params[:bucket_id])
    render json: bucket.comments
  end

  api :POST, '/comments'
  def create
    mentions = comment_params[:mentions]
    params[:comment].delete(:mentions)
    comment = Comment.create(comment_params)
    if mentions
      # turn the body markdown text into html for sending in an email
      body = body_as_markdown(comment_params[:body])
      bucket = Bucket.find(comment_params[:bucket_id])
      mentions.each do |userId|
        user = User.find(userId)
        UserMailer.notify_member_that_they_were_mentioned(author: current_user, member: user, bucket: bucket, body: body).deliver_now
      end
    end
    if comment.valid?
      render json: [comment]
    else
      render nothing: true, status: 422
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:bucket_id, :body, :mentions => []).merge(user_id: current_user.id)
    end

    def validate_user_is_group_member!
      render nothing: true, status: 403 and return unless current_user.is_member_of?(group)
    end

    def group
      return @group if @group
      bucket_id = params[:bucket_id] || comment_params[:bucket_id]
      @group = Bucket.find_by_id(bucket_id).group if bucket_id
    end

    # takes markdown and renders as html
    def body_as_markdown(body)
      renderer = Redcarpet::Render::HTML.new
      markdown = Redcarpet::Markdown.new(renderer, extensions = {})
      markdown.render(body).html_safe
    end
end
