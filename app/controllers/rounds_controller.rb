class RoundsController < ApplicationController

  respond_to :json

  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    respond_with round
  end

private
  def round
    @round ||= Round.find(params[:id])
  end
end
