class GroupsController < AuthenticatedController
  respond_to :json

  api :GET, '/groups', 'List groups'
  def index
    groups = Group.all
    render json: groups
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