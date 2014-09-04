class ProjectsController < ApplicationController
  inherit_resources

  belongs_to :round

  respond_to :json
  action :index

  api :GET, '/rounds/:round_id/buckets', 'List projects'
  def index
    index!
  end
end