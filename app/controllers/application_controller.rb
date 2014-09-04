class ApplicationController < ActionController::API
  include ActionController::MimeResponds
  include ActionController::ImplicitRender
  include CanCan::ControllerAdditions

  def current_user
    Person.first
  end

  def self.inherit_resources
    InheritedResources::Base.inherit_resources(self)
    initialize_resources_class_accessors!
    create_resources_url_helpers!
  end
end
