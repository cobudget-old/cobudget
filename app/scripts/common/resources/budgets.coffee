angular.module('resources.budgets', ['ngResource'])
.service("Budget", ['Restangular', (Restangular) ->
  getBudget: (budget_id)->
  getBudgetBuckets: (budget_id)->
    Restangular.one('budgets', budget_id).getList('buckets')
])
