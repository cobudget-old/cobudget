class UsersController < ApplicationController
  api :GET, '/users/', 'Get list of users'
  def index
    # TODO: delete this as soon as we implement invitations
    respond_with User.order('name ASC').all
  end

  api :POST, '/users/:user_id/change_password', "Change the user's password"
  def change_password
    user = User.find(params[:id])
    authorize user
    if user && user.valid_password?(params[:user][:old_password])
      if user.update(password: params[:user][:new_password], force_password_reset: false)
        head :no_content
      else
        render json: { errors: user.errors }, status: 400
      end
    else
      render json: { errors: { old_password: ["is incorrect"] } }, status: 400
    end
  end
end
