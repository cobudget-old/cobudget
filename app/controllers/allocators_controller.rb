class AllocatorsController < ApplicationController
  inherit_resources

  belongs_to :budget
  load_and_authorize_resource :budget
  load_and_authorize_resource :allocator, through: :budget

  respond_to :json
  action :index

  api :GET, '/budgets/:budget_id/allocators.json', 'Show allocators for a budget'
  def index
    render json: collection, each_serializer: FullAllocatorSerializer
  end
end