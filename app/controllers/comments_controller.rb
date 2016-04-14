class CommentsController < AuthenticatedController
  before_action :validate_user_is_group_member!

  api :GET, '/comments?bucket_id='
  def index
    bucket = Bucket.find(params[:bucket_id])
    render json: bucket.comments
  end

  api :POST, '/comments'
  def create
    comment = Comment.create(comment_params)
    if comment.valid?
      render json: [comment]
    else
      render nothing: true, status: 422
    end
  end

  private
    def comment_params
      params.require(:comment).permit(:bucket_id, :body).merge(user_id: current_user.id)
    end

    def validate_user_is_group_member!
      render nothing: true, status: 403 and return unless current_user.is_member_of?(group)
    end

    def group
      return @group if @group
      bucket_id = params[:bucket_id] || comment_params[:bucket_id]
      @group = Bucket.find_by_id(bucket_id).group if bucket_id
    end
end
