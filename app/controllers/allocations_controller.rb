require 'csv'

class AllocationsController < AuthenticatedController
  api :GET, '/allocations?group_id=', 'Get allocations for a particular group'
  def index
    group = Group.find(params[:group_id])
    render json: group.allocations
  end

  api :POST, '/allocations/upload_review'
  def upload_review
    file = params[:csv].tempfile
    csv = CSV.read(file)
    group = Group.find(params[:group_id])
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    if errors = AllocationService.check_csv_for_errors(csv: csv)
      render status: 422, json: {errors: errors}
    else
      upload_preview = AllocationService.generate_csv_upload_preview(csv: csv, group: group)
      render json: {data: upload_preview}
    end
  end

  api :POST, '/allocations/upload?group_id='
  def upload
    file = params[:csv].tempfile
    parsed_csv = CSV.read(file)
    group = Group.find(params[:group_id])
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    render nothing: true, status: 403 and return unless current_user.is_admin_for?(group)

    status = AllocationService.create_allocations_from_csv(
      parsed_csv: parsed_csv,
      group: group,
      current_user: current_user
    ) ? 200 : 422

    render nothing: true, status: status
  end

  api :POST, '/allocations?membership_id&amount'
  def create
    group = Group.find(allocation_params[:group_id])
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    allocation = Allocation.new(allocation_params)
    if allocation.save
      render json: [allocation], status: 201
    else
      render status: 400, nothing: true
    end
  end

  private
    def allocation_params
      params.require(:allocation).permit(:group_id, :user_id, :amount)
    end
end
