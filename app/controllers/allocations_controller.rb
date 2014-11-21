class AllocationsController < ApplicationController
  api :GET, '/rounds/:round_id/allocations/', 'Get allocation for a particular round'
  def index
    respond_with Round.find(params[:round_id]).allocations
  end

  api :POST, '/allocations/', 'Create allocation'
  def create
    # TODO: only allow group admins to create allocations
    respond_with Allocation.create(allocation_params)
  end

  api :PUT, '/allocations/:allocation_id', 'Update allocation'
  def update
    # Dumb hack due to restangular issues
    if params[:allocation].is_a?(String)
      params[:allocation] = JSON.parse(params[:allocation])
    end

    @allocation = Allocation.find(params[:id])
    respond_with @allocation.update_attributes(allocation_params)
  end

  private
    def allocation_params
      params.require(:allocation).permit(:user_id, :round_id, :amount_cents)
    end
end
