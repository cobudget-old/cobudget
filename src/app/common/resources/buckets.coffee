`// @ngInject`

angular.module('cobudget').service 'Bucket', (Restangular) ->

  get: (bucket_id)->
    Restangular.one('buckets', bucket_id).get()
 
  getBucketAllocations: (bucket_id)->
    Restangular.one('buckets', bucket_id).getList('allocations')
    
  sumBucketAllocations: (bucket)->
    sum = 0
    for allocation in bucket.allocations
      sum += allocation.amount
    sum

  getMyBucketContribution: (bucket, current_user_id) ->
    (_.find bucket.contributions, (contribution) ->
      contribution.user.id == current_user_id
    ) or {
      user_id: current_user_id
      bucket_id : bucket.id
      amount_cents: 0
    }

  getMyBucketContributionPercentage: (bucket, my_contribution) ->
      (my_contribution.amount_cents / bucket.target_cents) * 100