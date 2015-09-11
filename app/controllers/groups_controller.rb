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
    group = Group.create(group_params)
    render json: [group]
  end

  api :GET, '/groups/:id', 'Full details of group'
  def show
    @group = Group.find(params[:id])
    render json: [@group]
  end

private
  def group_params
    params.require(:group).permit(:name)
  end
end