class AllocationsController < AuthenticatedController
  api :GET, '/allocations?group_id=', 'Get allocations for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.allocations
  end
end
