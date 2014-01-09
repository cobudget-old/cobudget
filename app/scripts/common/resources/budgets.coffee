angular.module('resources.budgets', ['ngResource'])
.service("Budget", ['Restangular', (Restangular) ->
  budgets = Restangular.all('budgets')
  allBudgets: ()->
    budgets.getList()
  getBudgetBuckets: (budget_id)->
    Restangular.one('budgets', budget_id).getList('buckets')
])
