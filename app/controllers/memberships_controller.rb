class MembershipsController < ApplicationController
  api :POST, '/memberships/', 'Create membership'
  def create
    email = params[:membership].delete(:email)
    group = Group.find_by(id: membership_params_create[:group_id])
    return group_not_found_error unless group.present?
    membership = Membership.new(membership_params_create)
    if email && membership.member_id.blank?
      if user = User.find_by(email: email)
        membership.member_id = user.id
      else
        name = params[:membership][:name] 
        name ||= email[/[^@]+/]
        require 'SecureRandom'
        tmp_password = SecureRandom.hex(4)
        user = User.create!(email: email, name: name, password: tmp_password)
        membership.member_id = user.id
        # TODO: delayed_job or resque
        UserMailer.invite_email(user, current_user, group, tmp_password).deliver!
      end
    end
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
    params.require(:membership).permit(:member_id, :group_id, :is_admin)
  end

  def membership_params_update
    params.require(:membership).permit(:is_admin)
  end

  def group_not_found_error
    render(json: {errors: {group_id: ["group not found"]}}, status: 422)
  end
end
