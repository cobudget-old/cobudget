module Overrides
  class SessionsController < DeviseTokenAuth::SessionsController
    def create
      field = (resource_params.keys.map(&:to_sym) & resource_class.authentication_keys).first

      @resource = nil
      if field
        q_value = resource_params[field]

        if resource_class.case_insensitive_keys.include?(field)
          q_value.downcase!
        end

        q = "#{field.to_s} = ? AND provider='email'"

        if ActiveRecord::Base.connection.adapter_name.downcase.starts_with? 'mysql'
          q = "BINARY " + q
        end

        @resource = resource_class.where(q, q_value).first
      end

      if @resource and valid_params?(field, q_value) and @resource.valid_password?(resource_params[:password]) and (!@resource.respond_to?(:active_for_authentication?) or @resource.active_for_authentication?)
        # create client id
        @client_id = SecureRandom.urlsafe_base64(nil, false)
        @token     = SecureRandom.urlsafe_base64(nil, false)

        @resource.tokens[@client_id] = {
          token: BCrypt::Password.create(@token),
          expiry: (Time.now + DeviseTokenAuth.token_lifespan).to_i
        }
        @resource.save

        sign_in(:user, @resource, store: false, bypass: false)

        yield if block_given?

        render_create_success
      elsif not @resource.confirmed?
        render_create_error_not_confirmed
      else
        render_create_error_bad_credentials
      end
    end

    private
      def render_create_error_not_confirmed
        render json: {
          success: false,
          errors: [ "You have not yet confirmed your email address. We've sent another email to #{@resource.email}. Please check your inbox to continue."]
        }, status: 401
      end
  end
end
