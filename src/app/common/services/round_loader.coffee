angular.module('round-loader', [])
  .factory 'RoundLoader' , (Restangular, $routeParams, $stateParams, Round, Group)->
  
    new class RoundLoader
      getLatestRoundId: (group_id) ->
        Group.get(group_id).then (response) ->
          return response.latest_round_id

      getBuckets: (round_id) ->
        Restangular.one('rounds', round_id).get().then (response) ->
          response.buckets