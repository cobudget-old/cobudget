angular.module('round-loader', [])
  .factory 'RoundLoader' , (Restangular, $routeParams, $stateParams, Round, Organization)->
  
    new class RoundLoader
      getCurrentRoundId: (budget_id) ->
        Organization.get(budget_id).then (response) -> 
          return response.current_round_id


      getBuckets: (round_id) ->
        Restangular.one('round', round_id).get().then (response) ->
          console.log('get round res', response.buckets)
          response.buckets
