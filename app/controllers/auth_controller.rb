class AuthController < ApplicationController
  skip_before_filter :authenticate_from_token!, only: [:log_in]

  api :POST, '/auth/log_in', 'Returns an auth_token if user email/password are correct'
  def log_in
    user = User.find_by(email: params[:user][:email])
    if user && user.valid_password?(params[:user][:password])
      render json: { user: { id: user.id,
                             name: user.name,
                             email: user.email,
                             authentication_token: user.authentication_token
                             } }
    else
      render json: { error: 'Invalid email or password' }, status: 401
    end
  end
end
