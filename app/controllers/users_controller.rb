class UsersController < ApplicationController
  api :GET, '/users/', 'Get list of users'
  def index
    # TODO: delete this as soon as we implement invitations
    respond_with User.order('name ASC').all
  end

  api :POST, '/users/:user_id/change_password', "Change the user's password"
  def change_password
    # TODO: only allow user to change their own password
    user = User.find(params[:id])
    if user && user.valid_password?(params[:user][:old_password])
      if user.update(password: params[:user][:new_password])
        head :no_content
      else
        render json: { errors: user.errors }, status: 400
      end
    else
      head 400
    end
  end
end
