class AllocationsController < ApplicationController

  api :PUT, 'rounds/:round_id/allocations/', 'Get allocation for a particular round'
  def index
    respond_with Round.find(params[:round_id]).allocations
  end

  private
    def allocation_params
      params.require(:allocation).permit(:user_id, :amount_cents)
    end
end
