class CommentsController < AuthenticatedController
  api :GET, '/comments?bucket_id='
  def index
    bucket = Bucket.find(params[:bucket_id])
    render json: bucket.comments
  end
end