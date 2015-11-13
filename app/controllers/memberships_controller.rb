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

  def update
    membership = Membership.find(params[:id])
    membership.update(membership_params)
    render json: [membership]
  end

  def archive
    membership = Membership.find(params[:id])
    if current_user.is_admin_for?(membership.group)    
      membership.update(archived_at: DateTime.now.utc)
      render nothing: true, status: 200
    else 
      render nothing: true, status: 403
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:is_admin)
    end
end
