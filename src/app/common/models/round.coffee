`// @ngInject`
angular.module('cobudget').factory 'RoundModel',  (AllocationModel, BucketModel) ->
  class RoundModel
    constructor: (data = {}) ->
      @id = data.id
      @name = data.name
      @groupId = data.group_id
      @allocations = _.map data.allocations, (allocation) ->
        new AllocationModel(allocation)
      @buckets = _.map data.buckets, (bucket) ->
        new BucketModel(bucket)

    getMyContributions: ->
      @myContributions = _.map @buckets, (bucket) ->
        bucket.myContribution

    getMyAllocationsLeftCents: (myAllocationsCents) ->
      myContributionsCents = _.reduce _.pluck(@myContributions, "amountCents"), (sum, num) ->
        sum + num
      console.log(myAllocationsCents, myContributionsCents)
      @myAllocationsLeftCents = myAllocationsCents - myContributionsCents


    getStatus: ->
      if (@myAllocationsLeftCents >= 0)
        console.log('yay!')
        null
      else
        console.log('awe...')
        'warning'