class UsersController < AuthenticatedController

  skip_before_action :authenticate_user!, except: [:update_profile]

  api :POST, '/users/confirm_account'
  def confirm_account
    render status: 400, nothing: true and return unless valid_confirm_account_params?
    if user = User.find_by_confirmation_token(params[:confirmation_token])
      user.update(name: params[:name], password: params[:password])
      user.confirm!
      render json: [user]
    else
      render status: 403, nothing: true
    end
  end

  api :POST, '/users/invite_to_create_group?email'
  def invite_to_create_group
    user = User.create_with_confirmation_token(email: params[:email])
    if user.valid?
      UserMailer.join_cobudget_and_create_group_invite(user: user, inviter: current_user).deliver_later
      render status: 200, nothing: true
    else
      render status: 409, nothing: true
    end
  end

  api :POST, '/users/update_profile'
  def update_profile
    current_user.update(user_params)
    render json: [current_user]
  end

  api :POST, '/users/request_password_reset?email'
  def request_password_reset
    if user = User.find_by_email(params[:email])
      user.generate_reset_password_token! if user.confirmed?
      UserMailer.reset_password_email(user: user).deliver_later
      render nothing: true, status: 200
    else
      render nothing: true, status: 400
    end
  end

  api :POST, '/users/reset_password?password&confirm_password&reset_password_token'
  def reset_password
    if valid_reset_password_params?
      if user = User.find_by_reset_password_token(params[:reset_password_token])
        user.update(password: params[:password], reset_password_token: nil)
        render json: [user]
      else
        render nothing: true, status: 403
      end
    else
      render nothing: true, status: 422
    end
  end

  private
    def user_params
      params.require(:user).permit(
        :email,
        :utc_offset,
        :subscribed_to_personal_activity,
        :subscribed_to_daily_digest,
        :subscribed_to_participant_activity,
        :confirmation_token
      )
    end

    def valid_confirm_account_params?
      params[:confirmation_token].present? && params[:name].present? && params[:password].present?
    end

    def valid_reset_password_params?
      params[:reset_password_token] && params[:password] && params[:password] == params[:confirm_password]
    end
end
