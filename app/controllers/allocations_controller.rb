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
    user = User.find(allocation_params[:user_id])
    amount = allocation_params[:amount]
    notify = allocation_params[:notify]
    params[:allocation].delete(:notify)
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    allocation = Allocation.new(allocation_params)
    if allocation.save
      m = Membership.find_by(group_id: allocation_params[:group_id], member_id: allocation_params[:user_id])
      Transaction.create!({
        datetime: allocation.created_at,
        from_account_id: m.incoming_account_id,
        to_account_id: m.status_account_id,
        user_id: current_user.id,
        amount: amount
        })
      if notify && (amount > 0)
        UserMailer.notify_member_that_they_received_allocation(admin: current_user, member: user, group: group, amount: amount).deliver_later
      end
      render json: [allocation], status: 201
    else
      render status: 400, nothing: true
    end
  end

  private
    def allocation_params
      params.require(:allocation).permit(:group_id, :user_id, :amount, :notify)
    end
end
