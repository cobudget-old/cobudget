module Overrides
  class PasswordsController < DeviseTokenAuth::PasswordsController

    def create
      render json: {
        meow: "OH"
      }, status: 200
    end
    # def validate_token
    #   # @resource will have been set by set_user_by_token concern
    #   if @resource
    #     render json: {
    #       data: @resource.as_json(methods: :calculate_operating_thetan)
    #     }
    #   else
    #     render json: {
    #       success: false,
    #       errors: ["Invalid login credentials"]
    #     }, status: 401
    #   end
    # end
  end
end