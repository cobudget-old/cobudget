class ContributionsController < AuthenticatedController
  api :GET, '/contributions?bucket_id='
  def index
    contributions = Contribution.where(bucket_id: params[:bucket_id])
    render json: contributions
  end

  api :POST, '/contributions', 'Create new contribution'
  def create
    contribution = Contribution.create(contribution_params)
    ContributionService.send_bucket_received_contribution_emails(contribution: contribution)
    render json: [contribution]
  end

  private
    def contribution_params
      params.require(:contribution).permit(:bucket_id, :amount).merge(user_id: current_user.id)
    end
end
