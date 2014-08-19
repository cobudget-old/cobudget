window.Cobudget.Resources.Bucket = (Restangular) ->
  #  buckets = Restangular.all('buckets')
  #
  #  setMinMax: (bucket)->
  #    if bucket.minimum_cents?
  #      bucket.minimum = parseFloat(bucket.minimum_cents) / 100
  #    else
  #      bucket.minimum = 0
  #    if bucket.maximum_cents?
  #      bucket.maximum = parseFloat(bucket.maximum_cents) / 100
  #    else
  #      bucket.maximum = 0
  #    bucket
  #
  #  getBucket: (bucket_id)->
  #    Restangular.one('buckets', bucket_id).get()
  #
  #  createBucket: (bucket_data)->
  #    buckets.post('buckets', bucket_data)
  #
  #  getBucketAllocations: (bucket_id)->
  #    Restangular.one('buckets', bucket_id).getList('allocations')
  #
  #  createBucketAllocation: (bucket_id, allocation)->
  #    Restangular.post('buckets', budget_id)
  #
  #  setBucketState: (bucket_id, state)->
  #    #TODO Admin stuff
  #    Restangular.one('buckets', bucket_id).customPOST({bucket_id: bucket_id, state: state, admin_id: 1}, 'set-state')
  #
  #  sumBucketAllocations: (bucket)->
  #      sum = 0
  #      for allocation in bucket.allocations
  #        sum += allocation.amount
  #      sum

