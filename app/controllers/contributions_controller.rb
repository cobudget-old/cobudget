class ContributionsController < AuthenticatedController
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
