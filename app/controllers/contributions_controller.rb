class ContributionsController < AuthenticatedController
  api :POST, '/contributions', 'Create new contribution'
  def create
    contribution = Contribution.create(contribution_params_create)
    ContributionService.send_bucket_received_contribution_emails(contribution: contribution)
    render json: [contribution]
  end

  api :PUT, '/contributions/:id', 'Update contribution'
  def update
    update_resource contribution_params_update
  end

  api :DELETE, '/contributions/:id', 'Deletes contribution'
  def destroy
    destroy_resource
  end

  private
    def contribution_params_create
      params.require(:contribution).permit(:bucket_id, :amount).merge(user_id: current_user.id)
    end

    def contribution_params_update
      params.require(:contribution).permit(:amount)
    end
end
