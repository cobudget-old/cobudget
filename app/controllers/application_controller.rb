class ApplicationController < ActionController::API
# class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::Serialization
  # include ::ActionController::Cookies

  include TokenAuthentication
  before_filter :authenticate_from_token!

  include Pundit

  # protect_from_forgery with: :exception
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  respond_to :json

  def self.inherit_resources
    InheritedResources::Base.inherit_resources(self)
    initialize_resources_class_accessors!
    create_resources_url_helpers!
  end

private
  def user_not_authorized
    render json: { errors: { user: ["not authorized to do this"] } }, status: 403
  end

  # CRUD helpers
  #

  def resource
    @resource ||= controller_name.classify.constantize.find(params[:id])
  end

  def create_resource(parameters)
    resource = controller_name.classify.constantize.new(parameters)
    authorize resource
    resource.save
    respond_with resource
  end

  def update_resource(parameters)
    authorize resource
    respond_with resource.update_attributes(parameters)
  end

  def destroy_resource
    authorize resource
    respond_with resource.destroy
  end
end
