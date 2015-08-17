class CommentsController < AuthenticatedController
  api :GET, '/comments?bucket_id='
  def index
    bucket = Bucket.find(params[:bucket_id])
    render json: bucket.comments
  end

  api :POST, '/comments'
  def create
    comment = Comment.create(comment_params)
    render json: [comment]
  end

  private
    def comment_params
      params.require(:comment).permit(:bucket_id, :text).merge(user_id: current_user.id)
    end
end