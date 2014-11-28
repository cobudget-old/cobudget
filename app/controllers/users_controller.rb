class UsersController < ApplicationController
  api :GET, '/users/', 'Get list of users'
  def index
    # TODO: delete this as soon as we implement invitations
    respond_with User.order('name ASC').all
  end
end
