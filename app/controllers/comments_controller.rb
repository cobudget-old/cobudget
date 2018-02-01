class CommentsController < AuthenticatedController
  before_action :validate_user_is_group_member!

  api :GET, '/comments?bucket_id='
  def index
    bucket = Bucket.find(params[:bucket_id])
    render json: bucket.comments
  end

  api :POST, '/comments'
  def create
    body = comment_params[:body]
    new_body = ReverseMarkdown.convert body

    comment = Comment.create(body: new_body, user_id: comment_params[:user_id], bucket_id: comment_params[:bucket_id])
    noko_body = Nokogiri::HTML.fragment(body)
    user_links = noko_body.css("a").map {|a|
      a.attributes.values[1].value
    }

    noko_body.css("a").each do |a|
      a.attributes["href"].value = "#{Rails.application.config.action_mailer.default_url_options[:host]}/##{a['href']}"
    end

    if user_links
      email_body = noko_body.to_html.html_safe
      bucket = Bucket.find(comment_params[:bucket_id])
      user_links.each do |userId|
        user = User.find(userId)
        UserMailer.notify_member_that_they_were_mentioned(author: current_user, member: user, bucket: bucket, body: email_body).deliver_later
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
