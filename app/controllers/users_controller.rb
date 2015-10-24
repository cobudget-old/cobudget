class UsersController < AuthenticatedController

  skip_before_action :authenticate_user!, only: :confirm_account

  api :POST, '/users/confirm_account'
  def confirm_account
    if user = User.find_by_confirmation_token(params[:confirmation_token])
      user.update(name: params[:name], password: params[:password], confirmation_token: nil)
      render json: [user]
    else
      render status: 403, nothing: true
    end
  end

  api :POST, '/users?invite_group='
  def create
    user = User.create_with_confirmation_token(email: user_params[:email])
    UserMailer.invite_new_group_email(user: user, inviter: current_user).deliver_later
    render nothing: true
  end

  private 
    def user_params
      params.require(:user).permit(:email)
    end
end