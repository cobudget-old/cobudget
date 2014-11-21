class RoundsController < ApplicationController
  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    respond_with round
  end

  api :POST, '/rounds/', 'Create a round'
  def create
    # TODO: make sure only group admins can create new rounds
    respond_with Round.create(round_params)
  end

private
  def round
    @round ||= Round.find(params[:id])
  end

  def round_params
    params.require(:round).permit(:name, :group_id, :starts_at, :ends_at)
  end
end
