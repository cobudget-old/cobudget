require 'csv'

class AllocationsController < AuthenticatedController
  api :GET, '/allocations?group_id=', 'Get allocations for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.allocations
  end

  api :POST, '/allocations/upload?group_id='
  def upload
    file = params[:csv].tempfile
    csv = CSV.read(file)
    group = Group.find(params[:group_id])
    AllocationService.create_allocations_from_csv(csv: csv, group: group, current_user: current_user)
    render nothing: true, status: 200
  end
end
