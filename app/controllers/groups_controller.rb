class GroupsController < ApplicationController
  respond_to :json

  api :GET, '/groups', 'List groups'
  def index
    @groups = Group.all
    respond_with @groups
  end

  api :GET, '/groups/:organization_id', 'Full details of group'
  def show
    respond_with group
  end

private
  def group
    @group ||= Group.find(params[:id])
  end
end
