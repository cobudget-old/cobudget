class ContributionsController < AuthenticatedController
  api :GET, '/contributions?bucket_id= &group_id='
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
    current_membership_balance = Bucket.find_by_id(contribution_params[:bucket_id])
                                       .group.memberships
                                       .find_by_member_id(current_user.id)
                                       .balance.to_f
    if current_membership_balance >= contribution_params[:amount].to_f
      contribution = Contribution.create(contribution_params)
      ContributionService.send_bucket_received_contribution_emails(contribution: contribution)
      render json: [contribution], status: 201
    else
      render nothing: true, status: 403
    end
  end

  private
    def contribution_params
      params.require(:contribution).permit(:bucket_id, :amount).merge(user_id: current_user.id)
    end
end
