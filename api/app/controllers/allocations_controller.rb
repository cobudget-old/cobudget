require 'csv'

class AllocationsController < AuthenticatedController
  api :GET, '/allocations?group_id=', 'Get allocations for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.allocations
  end

  api :POST, '/allocations/upload_review'
  def upload_review
    file = File.read(params[:csv].tempfile).gsub(";", ",")
    csv = CSV.parse(file, col_sep: ',')
    group = Group.find(params[:group_id])
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    if errors = AllocationService.check_csv_for_errors(csv: csv, group: group)
      render status: 422, json: {errors: errors}
    else
      upload_preview = AllocationService.generate_csv_upload_preview(csv: csv, group: group)
      render json: {data: upload_preview}
    end
  end

  api :POST, '/allocations?membership_id&amount'
  def create
    group = Group.find(allocation_params[:group_id])
    notify = allocation_params[:notify]
    params[:allocation].delete(:notify)
    from_group_account = allocation_params[:from_group_account]
    params[:allocation].delete(:from_group_account)
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    if (allocation = AllocationService.create_allocation(allocation_params, notify, current_user))
      render json: [allocation], status: 201
    else
      render status: 400, nothing: true
    end
  end

  private
    def allocation_params
      params.require(:allocation).permit(:group_id, :user_id, :amount, :notify, :from_group_account)
    end
end
