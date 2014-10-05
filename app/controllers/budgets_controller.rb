class BudgetsController < ApplicationController
  inherit_resources

  load_and_authorize_resource :budget

  respond_to :json
  action :index, :show

  api :GET, '/budgets', 'List budgets'
  def index
    respond_with *with_chain(collection)
  end

  api :GET, '/budgets/:budget_id', 'Full details of budget'
  def show
    respond_with resource, serializer: FullBudgetSerializer
  end
end