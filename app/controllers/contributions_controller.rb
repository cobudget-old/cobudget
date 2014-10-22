class ContributionsController < ApplicationController
  api :POST, '/contributions', 'Create new contribution'
  def create
    respond_with Contribution.create(contribution_params)
  end

  api :PUT, '/contributions/:contribution_id', 'Update contribution'
  def update
  	@contribution = Contribution.find(params[:id])
    respond_with @contribution.update_attributes(contribution_params)
  end

  private
    def contribution_params
      params.permit(:bucket_id, :user_id, :amount_cents)
    end
end
