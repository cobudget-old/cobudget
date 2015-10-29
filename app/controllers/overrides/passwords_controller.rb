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
      pp params
      render nothing: true, status: 200
    end
  end
end