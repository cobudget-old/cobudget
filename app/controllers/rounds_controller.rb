class RoundsController < ApplicationController
  inherit_resources

  load_and_authorize_resource :round

  respond_to :json
  action :show

  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    show!
  end
end