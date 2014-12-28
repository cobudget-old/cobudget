class AllocationsController < ApplicationController
  api :GET, '/rounds/:round_id/allocations/', 'Get allocation for a particular round'
  def index
    respond_with Round.find(params[:round_id]).allocations
  end

  api :POST, '/allocations/', 'Create allocation'
  def create
    create_resource(allocation_params_create)
  end

  api :PUT, '/allocations/:allocation_id', 'Update allocation'
  def update
    update_resource(allocation_params_update)
  end

  private
    def allocation
      @allocation ||= Allocation.find(params[:id])
    end

    def allocation_params_create
      params.require(:allocation).permit(:user_id, :round_id, :amount_cents)
    end

    def allocation_params_update
      params.require(:allocation).permit(:amount_cents)
    end
end
