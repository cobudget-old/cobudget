class ContributionsController < ApplicationController
  api :POST, '/contributions', 'Create new contribution'
  def create
    contribution = Contribution.new(contribution_params_create)
    contribution.user = current_user
    contribution.save
    respond_with contribution
  end

  api :PUT, '/contributions/:contribution_id', 'Update contribution'
  def update
    @contribution = Contribution.find(params[:id])
    respond_with @contribution.update_attributes(contribution_params_update)
  end

  private
    def contribution_params_create
      params.require(:contribution).permit(:bucket_id, :amount_cents)
    end

    def contribution_params_update
      params.require(:contribution).permit(:amount_cents)
    end
end
