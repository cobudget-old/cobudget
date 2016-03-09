class MembershipsController < AuthenticatedController
  before_action :validate_user_is_group_admin!, only: [:create, :invite, :archive]
  before_action :validate_user_is_group_member!, only: [:index, :show]

  api :GET, 'memberships?group_id', 'Get memberships for a particular group'
  def index
    respond_to do |format|
      memberships = group.memberships.active
      format.json do
        render json: memberships
      end

      format.csv do
        csv = MembershipService.generate_csv(memberships: memberships)
        filename = "#{group.name}-member-data-#{Time.now.utc.iso8601}"
        send_data csv, type: "text/csv; charset=utf-8", disposition: 'attachment', filename: filename
      end
    end
  end

  api :POST, '/memberships?group_id&email'
  def create
    user = User.find_by_email(params[:email]) || User.create_with_confirmation_token(email: params[:email])
    render nothing: true, status: 400 and return unless user.valid?
    membership = Membership.create(member: user, group: group)
    render json: [membership]
  end

  api :GET, '/memberships/:id'
  def show
    render json: [membership], status: 200
  end

  api :GET, 'memberships/my_memberships', 'Get memberships for the current_user'
  def my_memberships
    render json: Membership.where(member_id: current_user.id).active
  end

  api :POST, '/memberships/:id/invite'
  def invite
    member, group = membership.member, membership.group
    member.generate_confirmation_token!
    UserMailer.invite_email(user: member, group: group, inviter: current_user, initial_allocation_amount: membership.balance.to_f).deliver_later
    render json: [membership], status: 200
  end

  def update
    membership.update(membership_params)
    render json: [membership]
  end

  def archive
    MembershipService.archive_membership(membership: membership)
    render nothing: true, status: 200
  end

  api :POST, '/memberships/upload_review?group_id&csv'
  def upload_review
    file = params[:csv].tempfile
    csv = CSV.read(file)
    group = Group.find(params[:group_id])
    render status: 403, nothing: true and return unless current_user.is_admin_for?(group)

    if errors = MembershipService.check_csv_for_errors(csv: csv)
      render status: 422, json: {errors: errors}
    else
      upload_preview = MembershipService.generate_csv_upload_preview(csv: csv, group: group)
      render json: {data: upload_preview}
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:is_admin)
    end

    def membership
      @membership ||= Membership.find_by_id(params[:id])
    end

    def group
      @group ||= (membership.group if membership) || Group.find_by_id(params[:group_id])
    end

    def validate_user_is_group_admin!
      render nothing: true, status: 403 and return unless current_user.is_admin_for?(group)
    end

    def validate_user_is_group_member!
      render nothing: true, status: 403 and return unless current_user.is_member_of?(group)
    end
end
