require 'securerandom'

class UsersController < AuthenticatedController

  skip_before_action :authenticate_user!, except: [:update_profile, :update_password, :me]

  api :POST, '/users/confirm_account'
  def confirm_account
    render status: 400, nothing: true and return unless valid_confirm_account_params?
    if user = User.find_by_confirmation_token(params[:confirmation_token])
      user.update(params.permit(:name, :password))
      user.confirm!
      render json: [user]
    else
      render status: 403, nothing: true
    end
  end

  api :POST, '/users?email'
  def create
    tmp_password = SecureRandom.hex
    user = User.create_with_confirmation_token(email: params[:user][:email], password: tmp_password)
    if user.valid?
      UserMailer.confirm_account_email(user: user).deliver_later
      render status: 200, json: { email: user.email, password: tmp_password }
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

  # TODO: refactor into service
  api :POST, '/users/update_password?current_password&password&confirm_password'
  def update_password
    render status: 401, nothing: true and return unless valid_update_password_params?
    render status: 401, json: { errors: ["current_password is incorrect"] } and return unless current_user.valid_password?(params[:current_password])
    render status: 400, json: { errors: ["passwords do not match"] } and return unless params[:password] == params[:confirm_password]
    current_user.update(password: params[:password])
    if current_user.valid?
      render status: 200, nothing: true
    else
      render status: 400, json: { errors: current_user.errors.full_messages }
    end
  end

  api :GET, '/users/me'
  def me
    render status: 200, json: [current_user]
  end

  private
    def user_params
      params.require(:user).permit(
        :name,
        :email,
        :utc_offset,
        :confirmation_token
      )
    end

    def valid_confirm_account_params?
      params[:confirmation_token].present? && params[:name].present? && params[:password].present?
    end

    def valid_reset_password_params?
      params[:reset_password_token].present? && params[:password].present? && params[:password] == params[:confirm_password]
    end

    def valid_update_password_params?
      params[:current_password].present? && params[:password].present? && params[:confirm_password].present?
    end
end
