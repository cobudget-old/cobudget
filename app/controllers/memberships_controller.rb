class MembershipsController < ApplicationController
  api :POST, '/memberships/', 'Create membership'
  def create
    # TODO: only allow group admins to create allocations
    respond_with Membership.create(membership_params)
  end

  api :PUT, '/memberships/:membership_id', 'Update membership'
  def update
    # Dumb hack due to restangular issues
    if params[:membership].is_a?(String)
      params[:membership] = JSON.parse(params[:membership])
    end

    @membership = Membership.find(params[:id])
    respond_with @membership.update_attributes(membership_params)
  end

  api :DELETE, '/memberships/:membership_id', 'Delete membership'
  def destroy
    respond_with Membership.find(params[:id]).destroy
  end

  api :GET, '/groups/:group_id/memberships/', 'Get memberships for a particular group'
  def index
    respond_with Group.find(params[:group_id]).memberships
  end

private
  def membership_params
    params.require(:membership).permit(:user_id, :group_id, :is_admin)
  end
end
