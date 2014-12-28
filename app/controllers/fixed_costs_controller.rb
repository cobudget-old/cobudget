class FixedCostsController < ApplicationController
  api :POST, '/fixed_costs', 'Create new fixed_cost'
  def create
    create_resource(fixed_cost_params_create)
  end

  api :GET, '/rounds/:round_id/fixed_costs/', 'Show fixed_costs for a particular round'
  def index
    respond_with Round.find(params[:round_id]).fixed_costs
  end

  api :PUT, '/fixed_costs/:fixed_cost_id', 'Update fixed_cost'
  def update
    update_resource(fixed_cost_params_update)
  end

  api :DELETE, '/fixed_costs/:fixed_cost_id', 'Delete fixed_cost'
  def destroy
    authorize fixed_cost
    respond_with fixed_cost.destroy
  end

  private
    def fixed_cost
      @fixed_cost ||= FixedCost.find(params[:id])
    end

    def fixed_cost_params_create
      params.require(:fixed_cost).permit(:round_id, :name, :amount_cents, :description)
    end

    def fixed_cost_params_update
      params.require(:fixed_cost).permit(:name, :amount_cents, :description)
    end
end
