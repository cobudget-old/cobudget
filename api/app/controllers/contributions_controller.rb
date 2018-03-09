class ContributionsController < AuthenticatedController
  before_action :validate_user_is_group_member!

  api :GET, '/contributions?bucket_id&group_id'
  def index
    contributions =
      if params[:group_id]
        # all contributions for group for current_user
        Contribution.joins(:bucket)
                    .where(user_id: current_user.id)
                    .where("buckets.group_id = ?", params[:group_id])
      else
        # all contributions for bucket
        Contribution.where(bucket_id: params[:bucket_id])
      end
    render json: contributions
  end

  api :POST, '/contributions', 'Create new contribution'
  def create
    contribution = ActiveRecord::Base.transaction do
      bucket = Bucket.find(params[:contribution][:bucket_id])
      membership = Membership.find_by(member_id: current_user.id, group_id: bucket.group_id)
      amount = [bucket.target - bucket.total_contributions, params[:contribution][:amount].to_d].min      
      contribution = Contribution.create(contribution_params)
      # Contribution.valid? here tests if the contribution has failed because the member was
      # overdrafting his account
      if contribution.valid? && amount > 0
        transaction = Transaction.create!({
            datetime: contribution.created_at,
            from_account_id: membership.status_account_id,
            to_account_id: bucket.account_id,
            user_id: current_user.id,
            amount: amount
          })
      end
      contribution
    end

    if contribution.valid?
      render json: [contribution]
    else
      render json: contribution.errors.full_messages, status: 422
    end
  end

  private
    def contribution_params
      params.require(:contribution).permit(:bucket_id, :amount).merge(user_id: current_user.id)
    end

    def validate_user_is_group_member!
      render nothing: true, status: 403 and return unless current_user.is_member_of?(group)
    end

    def group
      return @group if @group
      group_id = params[:group_id] || Bucket.find_by_id(params[:bucket_id] || contribution_params[:bucket_id]).group_id
      @group = Group.find_by_id(group_id) if group_id
    end
end
