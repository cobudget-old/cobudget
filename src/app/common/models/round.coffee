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
      if (@myAllocationsLeftCents > 0)
        null
      else if (@myAllocationsLeftCents == 0)
        'complete'
      else
        'warning'

    getContributors: () ->
      contributors = {}

      # start contributors with allocations
      _.each @allocations, (allocation) ->
        person = _.clone(allocation.user)

        person.allocationCents = allocation.amountCents
        person.allocation = person.allocationCents / 100

        contributors[person.id] = person

      # for each bucket
      _.each @buckets, (bucket) ->
        contributions = bucket.getContributionsByUser()

        # add contributions to contributors
        _.each contributions, (contribution, userId) ->

          person = contributors[userId]

          if not person.contributionCents
            person.contributionCents = contribution.amountCents
          else
            person.contributionCents += contribution.amountCents

          person.contribution = person.contributionCents / 100

      contributors
