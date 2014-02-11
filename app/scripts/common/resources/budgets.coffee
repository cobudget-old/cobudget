angular.module('resources.budgets', ['ngResource'])
.service("Budget", ['Restangular', (Restangular) ->
  budgets = Restangular.all('budgets')
  getBudget: (budget_id)->
    Restangular.one('budgets', budget_id).get()
  allBudgets: ()->
    budgets.getList()
  getBudgetBuckets: (budget_id)->
    Restangular.one('budgets', budget_id).getList('buckets')
  createBudget: (budget_data)->
    budgets.post('budgets', budget_data)
])
