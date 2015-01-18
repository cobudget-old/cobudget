class MembershipsController < ApplicationController
  api :POST, '/memberships/', 'Create membership'
  def create
    create_resource(membership_params_create)
  end

  api :PUT, '/memberships/:membership_id', 'Update membership'
  def update
    update_resource(membership_params_update)
  end

  api :DELETE, '/memberships/:membership_id', 'Delete membership'
  def destroy
    destroy_resource
  end

  api :GET, '/groups/:group_id/memberships/', 'Get memberships for a particular group'
  def index
    respond_with Group.find(params[:group_id]).memberships.includes('member').order('users.name ASC'), each_serializer: MembershipSerializer
  end

private
  def membership
    @membership ||= Membership.find(params[:id])
  end

  def membership_params_create
    params.require(:membership).permit(:member_id, :group_id, :is_admin)
  end

  def membership_params_update
    params.require(:membership).permit(:is_admin)
  end
end
