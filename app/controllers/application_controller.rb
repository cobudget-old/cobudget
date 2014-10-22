class ApplicationController < ActionController::API
# class ApplicationController < ActionController::Base
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include ActionController::Serialization
  # include ::ActionController::Cookies

  include TokenAuthentication

  # protect_from_forgery with: :exception

  respond_to :json

  def self.inherit_resources
    InheritedResources::Base.inherit_resources(self)
    initialize_resources_class_accessors!
    create_resources_url_helpers!
  end
end
