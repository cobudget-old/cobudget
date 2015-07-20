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
    update_resource(round_params)
  end

  api :DELETE, '/rounds/:round_id', 'Deletes a round'
  def destroy
    destroy_resource
  end

  api :POST, '/rounds/:round_id/allocations/upload', 'Generates allocations for round from csv'
  def upload
    load_and_authorize_round
    csv = CSV.read(params[:csv].tempfile)
    @round.delay.generate_new_members_and_allocations_from!(csv, current_user)
    render status: 201, json: { message: "upload successful" }
  end

  api :PUT, '/rounds/:id/open_for_proposals'
  def open_for_proposals
    load_and_authorize_round
    @round.assign_attributes(round_params)
    RoundService.open_for_proposals(round: @round, admin: current_user)
    respond_with_round
  end

  api :PUT, '/rounds/:id/open_for_contributions'
  def open_for_contributions
    load_and_authorize_round
    @round.assign_attributes(round_params)
    RoundService.open_for_contributions(round: @round, admin: current_user)
    respond_with_round
  end

private
  def round_params
    params.require(:round).permit(:name, :starts_at, :ends_at, :members_can_propose_buckets)
  end

  def round_params_create
    params.require(:round).permit(:group_id, :name, :starts_at, :ends_at, :members_can_propose_buckets)
  end

  def load_and_authorize_round
    @round = Round.find_by_id(params[:id])
    authorize @round
  end

  def respond_with_round
    if @round.errors.any?
      render status: 422, json: { errors: @round.errors.full_messages }
    else
      render status: 200, json: @round.as_json(only: [:id, :starts_at, :ends_at])
    end
  end
end