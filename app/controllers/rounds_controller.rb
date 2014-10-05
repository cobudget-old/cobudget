class RoundsController < ApplicationController
  inherit_resources

  load_and_authorize_resource :round

  respond_to :json
  action :show

  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    show!
  end

  api :GET, '/rounds', 'Short and sweet index of all rounds'
  def index
    @rounds = Budget.includes(:latest_round).all.map(&:latest_round)
    respond_with @rounds, each_serializer: RoundIdentitySerializer
  end
end