module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController

    def create
      if user = User.find_by_email(params[:email])
        if user.has_set_up_account?
          user.update(reset_password_token: SecureRandom.urlsafe_base64.to_s)
        end
        UserMailer.reset_password_email(user: user).deliver_later
        render nothing: true, status: 200
      else
        render nothing: true, status: 400
      end
    end

    def update
      if params[:reset_password_token] && params[:password] && params[:password] == params[:confirm_password]
        if user = User.find_by_reset_password_token(params[:reset_password_token])
          user.update(password: params[:password], reset_password_token: nil)
          render nothing: true, status: 204
        else
          render nothing: true, status: 403
        end
      else
        render nothing: true, status: 422
      end
    end

  end
end