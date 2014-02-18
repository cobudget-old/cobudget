angular.module('resources.budgets', ['ngResource'])
.service("Budget", ['Restangular', (Restangular) ->
  budgets = Restangular.all('budgets')
  getBudget: (budget_id)->
    Restangular.one('budgets', budget_id).get()
  allBudgets: ()->
    budgets.getList()
  getBudgetBuckets: (budget_id, state)->
    state ||= "open"
    Restangular.one('budgets', budget_id).customGET('buckets', {state: state})
  createBudget: (budget_data)->
    budgets.post('budgets', budget_data)
])
