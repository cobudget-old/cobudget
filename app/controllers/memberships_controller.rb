class MembershipsController < AuthenticatedController
  api :GET, 'memberships?group_id', 'Get memberships for a particular group'
  def index
    group = Group.find(params[:group_id])
    if current_user.is_member_of?(group)
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
    else
      render nothing: true, status: 403
    end
  end

  api :POST, '/memberships?group_id&email'
  def create
    group = Group.find(params[:group_id])
    email = params[:email]
    render nothing: true, status: 403 and return unless current_user.is_admin_for?(group)

    if user = User.find_by_email(email)
      membership = Membership.create(member: user, group: group)
      render json: [membership]
    else
      user = User.create_with_confirmation_token(email: email)
      if user.valid?
        membership = Membership.create(member: user, group: group)
        render json: [membership]
      else
        render nothing: true, status: 400
      end
    end
  end

  api :GET, '/memberships/:id'
  def show
    membership = Membership.find(params[:id])
    group = membership.group
    if current_user.is_member_of?(group)
      render json: [membership], status: 200
    else
      render nothing: true, status: 403
    end
  end

  api :GET, 'memberships/my_memberships', 'Get memberships for the current_user'
  def my_memberships
    render json: Membership.where(member_id: current_user.id).active
  end

  api :POST, '/memberships/:id/invite'
  def invite
    membership = Membership.find(params[:id])
    if current_user.is_admin_for?(membership.group)
      member, group = membership.member, membership.group
      member.generate_confirmation_token!
      UserMailer.invite_email(user: member, group: group, inviter: current_user, initial_allocation_amount: membership.balance.to_f).deliver_later
      render json: [membership], status: 200
    else
      render nothing: true, status: 403
    end
  end

  def update
    membership = Membership.find(params[:id])
    membership.update(membership_params)
    render json: [membership]
  end

  def archive
    membership = Membership.find(params[:id])
    if current_user.is_admin_for?(membership.group)
      MembershipService.archive_membership(membership: membership)
      render nothing: true, status: 200
    else
      render nothing: true, status: 403
    end
  end

  private
    def membership_params
      params.require(:membership).permit(:is_admin)
    end
end
