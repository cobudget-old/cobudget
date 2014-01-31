angular.module('resources.buckets', [])
.service("Bucket", ['Restangular', (Restangular) ->
  buckets = Restangular.all('buckets')

  setMinMax: (bucket)->
    if bucket.minimum_cents?
      bucket.minimum = parseFloat(bucket.minimum_cents) / 100
    if bucket.maximum_cents?
      bucket.maximum = parseFloat(bucket.maximum_cents) / 100
    bucket

  getBucket: (bucket_id)->
    Restangular.one('buckets', bucket_id).get()

  createBucket: (bucket_data)->
    buckets.post('buckets', bucket_data)

  getBucketAllocations: (bucket_id)->
    Restangular.one('buckets', bucket_id).getList('allocations')

  createBucketAllocation: (bucket_id, allocation)->
    Restangular.post('buckets', budget_id)
])
