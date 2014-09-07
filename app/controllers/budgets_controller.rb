class BudgetsController < ApplicationController
  inherit_resources

  load_and_authorize_resource :budget

  respond_to :json
  action :index

  api :GET, '/budgets', 'List budgets'
  def index
    respond_with *with_chain(collection)
  end
end