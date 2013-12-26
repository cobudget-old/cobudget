angular.module('resources.buckets', [])
.service("Bucket", ['Restangular', (Restangular) ->
  getBucket: (bucket_id)->
  getBucketAllocations: (bucket_id)->
    Restangular.one('buckets', budget_id).getList('allocations')
  createBucketAllocation: (bucket_id, allocation)->
    Restangular.post('buckets', budget_id)
])
