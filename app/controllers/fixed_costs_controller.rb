class FixedCostsController < ApplicationController
  api :POST, '/fixed_costs', 'Create new fixed_cost'
  def create
    respond_with FixedCost.create(fixed_cost_params)
  end

  api :GET, '/rounds/:round_id/fixed_costs/', 'Show fixed_costs for a particular round'
  def index
    respond_with Round.find(params[:round_id]).fixed_costs
  end

  api :PUT, '/fixed_costs/:fixed_cost_id', 'Update fixed_cost'
  def update
    # Dumb hack due to restangular issues
    if params[:fixed_cost].is_a?(String)
      params[:fixed_cost] = JSON.parse(params[:fixed_cost])
    end

    @fixed_cost = FixedCost.find(params[:id])
    respond_with @fixed_cost.update_attributes(fixed_cost_params)
  end

  private
    def fixed_cost_params
      params.require(:fixed_cost).permit(:round_id, :name, :amount_cents, :description)
    end
end
