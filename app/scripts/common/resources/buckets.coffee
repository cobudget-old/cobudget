angular.module('resources.buckets', ['ngResource'])
.factory("Bucket", ["$resource", "API_PREFIX", ($resource, API_PREFIX) ->
  $resource("#{API_PREFIX}/list_buckets?budget_id=:budget_id",
    {budget_id: "@budget_id"},
    update: 
      method: "PUT"
  )
])
