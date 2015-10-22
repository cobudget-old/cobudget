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

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy
    render nothing: true
  end

  private
    def membership_params
      params.require(:membership).permit(:is_admin)
    end
end
