class AuthController < ApplicationController
  def sign_in
    user = User.find_by(email: params[:email])
    if user
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
