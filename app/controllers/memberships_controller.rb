class MembershipsController < AuthenticatedController
  api :GET, 'memberships?group_id=', 'Get memberships for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.memberships
  end

  api :GET, 'memberships/my_memberships', 'Get memberships for the current_user'
  def my_memberships
    render json: Membership.where(member_id: current_user.id)
  end
end
