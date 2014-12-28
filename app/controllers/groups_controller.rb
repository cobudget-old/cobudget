class GroupsController < ApplicationController
  respond_to :json

  api :GET, '/groups', 'List groups'
  def index
    @groups = Group.all
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
