require 'csv'

class AllocationsController < AuthenticatedController
  api :GET, '/allocations?group_id=', 'Get allocations for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.allocations
  end

  api :POST, '/allocations/upload?group_id='
  def upload
    csv = CSV.read(params[:csv].tempfile)
    group = Group.find(params[:group_id])
    pp csv
    render json: "fuck lol"
  end
end
