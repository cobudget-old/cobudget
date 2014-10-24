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