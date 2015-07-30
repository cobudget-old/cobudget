class GroupsController < AuthenticatedController
  respond_to :json

  api :GET, '/groups', 'List groups'
  def index
    if params[:member_id]
      @groups = Group.includes('memberships').where(memberships: { member_id: params[:member_id] }).all
    else
      @groups = Group.all
    end
    respond_with @groups
  end

  api :POST, '/groups', 'Create a group'
  def create
    group = create_resource(group_params_create, respond: false)
    group.add_admin(current_user)
    respond_with group
  end

  api :GET, '/groups/:organization_id', 'Full details of group'
  def show
    respond_with resource
  end

private
  def group_params_create
    params.require(:group).permit(:name)
  end
end