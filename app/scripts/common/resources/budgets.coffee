angular.module('resources.budgets', ['ngResource'])
.factory("Budget", ["$resource", "API_PREFIX", ($resource, API_PREFIX) ->
  #moved to bucket for now
  $resource("#{API_PREFIX}/list_buckets?budget_id=:id.json",
    {id: "@id"},
    update: 
      method: "PUT"
  )
])
