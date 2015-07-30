class MembershipsController < AuthenticatedController
  api :POST, '/memberships/', 'Create membership'
  def create
    group = Group.find_by(id: membership_params_create[:group_id])
    return group_not_found_error unless group.present?

    member_id = params[:membership][:member][:id]
    email = params[:membership][:member].delete(:email)

    if member_id
      member = User.find(member_id)
    elsif email
      if not (member = User.find_by(email: email))
        name = params[:membership][:member][:name]
        name ||= email[/[^@]+/]
        require 'securerandom'
        tmp_password = SecureRandom.hex(4)
        member = User.create!(email: email, name: name, password: tmp_password)
        UserMailer.invite_email(member, current_user, group, tmp_password).deliver_later!
      end
    end

    membership = Membership.new(membership_params_create)
    membership.member = member

    authorize membership
    membership.save
    respond_with membership
  end

  api :PUT, '/memberships/:membership_id', 'Update membership'
  def update
    update_resource(membership_params_update)
  end

  api :DELETE, '/memberships/:membership_id', 'Delete membership'
  def destroy
    destroy_resource
  end

  api :GET, '/groups/:group_id/memberships/', 'Get memberships for a particular group'
  def index
    respond_with Group.find(params[:group_id]).memberships.includes('member').order('users.name ASC'), each_serializer: MembershipSerializer
  end

private
  def membership
    @membership ||= Membership.find(params[:id])
  end

  def membership_params_create
    params.require(:membership).permit(:group_id, :is_admin)
  end

  def membership_params_update
    params.require(:membership).permit(:is_admin)
  end

  def group_not_found_error
    render(json: {errors: {group_id: ["group not found"]}}, status: 422)
  end
end
