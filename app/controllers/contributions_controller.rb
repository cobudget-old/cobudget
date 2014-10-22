class ContributionsController < ApplicationController
  api :POST, '/contributions', 'Create new contribution'
  def create
    contribution = Contribution.new(contribution_params)
    contribution.user = current_user
    contribution.save
    respond_with contribution
  end

  api :PUT, '/contributions/:contribution_id', 'Update contribution'
  def update
  	@contribution = Contribution.find(params[:id])
    respond_with @contribution.update_attributes(contribution_params)
  end

  private
    def contribution_params
      params.require(:contribution).permit(:bucket_id, :amount_cents)
    end
end
