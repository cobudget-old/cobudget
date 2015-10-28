module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController

    def create
      if user = User.find_by_email(params[:email])
        render nothing: true, status: 200
      else
        render nothing: true, status: 400
      end
    end
  end
end