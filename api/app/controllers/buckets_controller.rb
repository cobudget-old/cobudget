class BucketsController < AuthenticatedController
  api :GET, '/buckets?group_id'
  def index
    buckets = Bucket.includes(:group, user: [:subscription_tracker]).with_totals.where(group_id: params[:group_id])
    render json: buckets
  end

  api :GET, '/buckets/:id', 'Full details of bucket'
  def show
    bucket = Bucket.with_totals.find(params[:id])
    render json: [bucket]
  end

  api :POST, '/buckets', 'Create a bucket'
  def create
    bucket = Bucket.new(bucket_params_create)
    if bucket.save
      render json: [bucket]
    else
      render json: {
        errors: bucket.errors.full_messages
      }, status: 400
    end
  end

  api :PATCH, '/buckets/:id', 'Update a bucket'
  def update
    bucket = Bucket.with_totals.find(params[:id])
    render status: 403, nothing: true and return unless bucket.is_editable_by?(current_user) && 
      (bucket.is_idea? || bucket.is_funding? || bucket.is_funded?)
    bucket.update_attributes(bucket_params_update)
    if bucket.save
      render json: [bucket]
    else
      render json: {
        errors: bucket.errors.full_messages
      }, status: 400
    end
  end

  api :POST, '/buckets/:id/open_for_funding'
  def open_for_funding
    bucket = Bucket.with_totals.find(params[:id])
    render status: 403, nothing: true and return unless bucket.is_editable_by?(current_user) && bucket.is_idea?
    bucket.update(status: "live")
    render json: [bucket]
  end

  api :POST, '/buckets/:id/archive'
  def archive
    bucket = Bucket.with_totals.find(params[:id])
    group = bucket.group
    render nothing: true, status: 403 and return unless ((current_user.is_member_of?(group) && bucket.user == current_user) || current_user.is_admin_for?(group)) && 
      (bucket.is_idea? || bucket.is_funding? || bucket.is_funded?)
    BucketService.archive(bucket, current_user)
    render json: [bucket], status: 200
  end

  api :POST, '/buckets/:id/paid'
  def paid
    bucket = Bucket.with_totals.find(params[:id])
    group = bucket.group
    render nothing: true, status: 403 and return unless ((current_user.is_member_of?(group) && bucket.user == current_user) || current_user.is_admin_for?(group)) &&
      bucket.is_funded?
    ActiveRecord::Base.transaction do
      bucket.update(paid_at: Time.now.utc, archived_at: nil)
      membership = Membership.where("member_id = ? AND group_id = ?", bucket.user_id, bucket.group_id).first
      total_contributions = Account.find(bucket.account_id).balance
      transaction = Transaction.create!({
          datetime: bucket.paid_at,
          from_account_id: bucket.account_id,
          to_account_id: membership.outgoing_account_id,
          user_id: current_user.id,
          amount: total_contributions
        })
    end
    render json: [bucket], status: 200
  end

  private
    def bucket_params_create
      params.require(:bucket).permit(:name, :description, :group_id, :target).merge(user_id: current_user.id)
    end

    def bucket_params_update
      params.require(:bucket).permit(:name, :description, :target, :status)
    end
end
