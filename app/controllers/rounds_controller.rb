class RoundsController < ApplicationController
  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    respond_with round
  end

  api :POST, '/rounds/', 'Create a round'
  def create
    create_resource(round_params_create)
  end

  api :DELETE, '/rounds/:round_id', 'Deletes a round'
  def destroy
    destroy_resource
  end

private
  def round
    @round ||= resource
  end

  def round_params_create
    params.require(:round).permit(:name, :group_id, :starts_at, :ends_at)
  end
end
