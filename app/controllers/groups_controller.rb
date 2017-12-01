class GroupsController < AuthenticatedController
  respond_to :json

  api :GET, '/groups', 'List groups'
  def index
    groups = Group.joins(:memberships).where(memberships: {member_id: current_user.id})
    render json: groups
  end

  api :POST, '/groups', 'Create a group'
  def create
    group = Group.create(group_params)
    group.add_admin(current_user)
    render json: [group]
  end

  api :GET, '/groups/:id', 'Full details of group'
  def show
    group = Group.find(params[:id])
    if current_user.is_member_of?(group)
      membership = group.memberships.where(member_id: current_user.id, group_id: group.id)
      render json: [group, membership]
    else
      render status: 403, nothing: true
    end
  end

  api :PATCH, '/groups/:id', 'Update a group'
  def update
    group = Group.find(params[:id])
    group.update(group_params)
    render json: [group]
  end

  api :POST, '/groups/:id/add_customer', 'Add a credit card that pays for the group'
  def add_customer
    group = Group.find(params[:id])
    if current_user.is_admin_for(group)
      group.add_customer(current_user.email)
      render json: [group]
    else
      render nothing: true, status: 403
    end
  end

  api :POST, '/groups/:id/add_card', 'Add a credit card that pays for the group'
  def add_card
    group = Group.find(params[:id])
    if current_user.is_admin_for?(group)
      group.add_card(params[:stripeEmail], params[:stripeToken])
      render status: 200, nothing: true
    else
      render status: 403, nothing: true
    end
  end

  api :POST, '/groups/:id/extend_trial', 'Extend the group trial by 30 days'
  def extend_trial
    group = Group.find(params[:id])
    if current_user.is_admin_for?(group)
      group.extend_trial()
      render status: 200, nothing: true
    else
      render status: 403, nothing: true
    end
  end

  private
    def group_params
      params.require(:group).permit(:name, :currency_code, :plan)
    end
end
