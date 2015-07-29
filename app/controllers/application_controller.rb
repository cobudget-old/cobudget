class ApplicationController < ActionController::API
# class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  # include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::Serialization
  # include ::ActionController::Cookies

  ### commenting this out for now, this is the former authentication scheme 
  # include TokenAuthentication
  # before_filter :authenticate_from_token!

  include Pundit

  # protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :json

private
  def user_not_authorized
    render json: { errors: { user: ["not authorized to do this"] } }, status: 403
  end

  # CRUD helpers
  #

  def resource
    @resource ||= controller_name.classify.constantize.find(params[:id])
  end

  def create_resource(controller_params, **args)
    resource = controller_name.classify.constantize.new(controller_params)
    authorize resource
    resource.save
    if args[:respond] == false
      resource
    else
      respond_with resource
    end
  end

  def update_resource(controller_params)
    authorize resource
    respond_with resource.update_attributes(controller_params)
  end

  def destroy_resource
    authorize resource
    respond_with resource.destroy
  end
end
