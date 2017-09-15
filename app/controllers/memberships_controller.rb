require 'csv'

class MembershipsController < AuthenticatedController
  before_action :validate_user_is_group_admin!, only: [:create, :invite, :archive]
  before_action :validate_user_is_group_member!, only: [:index, :show]

  api :GET, 'memberships?group_id', 'Get memberships for a particular group'
  def index
    respond_to do |format|
      memberships = group.memberships.includes(member: [:subscription_tracker]).with_totals.active
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

  api :POST, '/memberships?group_id&email&name'
  def create
    user = User.find_by_email(params[:email].downcase) || User.create_with_confirmation_token(email: params[:email], name: params[:name])
    render nothing: true, status: 400 and return unless user.valid?
    if membership = Membership.find_by(member: user, group: group)
      if membership.active?
        render nothing: true, status: 409
      else
        membership.reactivate!
        render json: [membership.reload]
      end
    else
      membership = group.add_member(user)
      render json: [membership]
    end
  end

  api :GET, '/memberships/:id'
  def show
    render json: [membership], status: 200
  end

  api :GET, 'memberships/my_memberships?group_id', 'Get memberships for the current_user'
  def my_memberships
    memberships = Membership.with_totals.where(member_id: current_user.id).active
    if current_user.is_super_admin && (params.key?(:group_id) && params[:group_id] != "null") &&
      group = Group.find(params[:group_id])
      print "*******************************\n\n"
      print "*******************************\n\n"
      print "*******************************\n\n"
      print "*******************************\n\n"
      print "*******************************\n\n"
      print group
      m = memberships.select { |m| m.group_id == group.id}.first
      # admin is not already a member of this group, make a fake membership
      if not m
        fake_membership = memberships.first.dup
        fake_membership.id = 1
        fake_membership.is_admin = true
        fake_membership.total_contributions_db = 0
        fake_membership.total_allocations_db = 0
        m = fake_membership.dup
        m.group_id = group.id
        memberships.push(m)
      end
    end
    render json: memberships
  end

  api :POST, '/memberships/:id/invite'
  def invite
    member, group = membership.member, membership.group
    member.generate_confirmation_token! unless member.confirmed?
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
      params.require(:membership).permit(:is_admin, :closed_admin_help_card_at, :closed_member_help_card_at)
    end

    def membership
      @membership ||= Membership.with_totals.find_by_id(params[:id])
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
