angular.module('resources.budgets', ['ngResource'])
.factory("Budget", ["$resource", "API_PREFIX", ($resource, API_PREFIX) ->
  $resource("#{API_PREFIX}/list_buckets?budget_id=:id.json",
    {id: "@id"},
    update: 
      method: "PUT"
  )
])
