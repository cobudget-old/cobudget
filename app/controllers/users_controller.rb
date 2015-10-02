class UsersController < AuthenticatedController

  skip_before_action :authenticate_user!, only: :confirm_account

  api :POST, '/users/confirm_account'
  def confirm_account
    if user = User.find_by_confirmation_token(params[:confirmation_token])
      user.update(name: params[:name], password: params[:password], confirmation_token: nil)
      render json: [user]
    else
      render nothing: true, status: 401
    end
  end

end