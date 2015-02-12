class UsersController < ApplicationController
  api :GET, '/users/', 'Get list of users'
  def index
    # TODO: delete this as soon as we implement add-user-to-group on the UI
    respond_with User.order('name ASC').all
  end

  def update
    authorize user
    initialize_user_update_params
    user.initialized = true
    user.update(@user_update_params)
    respond_with user
  end

  api :POST, '/users/:user_id/change_password', "Change the user's password"
  def change_password
    user = User.find(params[:id])
    authorize user
    if user && user.valid_password?(params[:user][:old_password])
      if user.update(password: params[:user][:new_password])
        head :no_content
      else
        render json: { errors: user.errors }, status: 400
      end
    else
      render json: { errors: { old_password: ["is incorrect"] } }, status: 400
    end
  end

  private
    def user
      @user ||= User.find(params[:id])
    end

    def initialize_user_update_params
      if @user_update_params
        @user_update_params
      else
        permitted = [:name, :email]
        permitted << [:password] unless user.initialized?
        @user_update_params ||= params.require(:user).permit(*permitted)
      end
    end
end
