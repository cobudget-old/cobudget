`// @ngInject`

angular.module('cobudget').service 'BucketService', (Restangular, BucketModel, ContributionModel) ->

  get: (bucketId)->
    Restangular.one('buckets', bucketId).get()
    .then (bucket) ->
      new BucketModel(bucket.plain())
 
  getBucketAllocations: (bucketId)->
    Restangular.one('buckets', bucketId).getList('allocations')
    
  sumBucketAllocations: (bucket)->
    sum = 0
    for allocation in bucket.allocations
      sum += allocation.amount
    sum