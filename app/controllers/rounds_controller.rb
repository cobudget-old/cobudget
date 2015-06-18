require 'csv'

class RoundsController < ApplicationController
  api :GET, '/rounds/:round_id', 'Full details of round'
  def show
    respond_with resource
  end

  api :POST, '/rounds', 'Create a round'
  def create
    create_resource(round_params_create)
  end

  api :PUT, '/rounds/:round_id', 'Update a round'
  def update
    update_resource(round_params_update)
  end

  api :DELETE, '/rounds/:round_id', 'Deletes a round'
  def destroy
    destroy_resource
  end

  api :POST, '/rounds/:round_id/upload_csv', 'generates allocations for round from csv'
  def upload_csv
    csv = params[:csv].tempfile
    Round.generate_allocations_from(csv)
    render status: 200
  end

private
  def round_params_create
    params.require(:round).permit(:name, :group_id, :starts_at, :ends_at, :members_can_propose_buckets)
  end

  def round_params_update
    params.require(:round).permit(:name, :starts_at, :ends_at, :members_can_propose_buckets)
  end
end
