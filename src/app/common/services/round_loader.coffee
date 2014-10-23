angular.module('round-loader', [])
  .factory 'RoundLoader' , (Restangular, $routeParams, $stateParams, Round, Group)->
  
    new class RoundLoader
      getLatestRoundId: (group_id) ->
        Group.get(group_id).then (response) ->
          return response.latest_round_id

      getContributorDetails: (roundId, userId) ->
        Restangular.one('rounds', roundId).one('contributors', userId).get().then (details) ->
          details.totalContributionsCents = 0
          for contribution in details.contributions
            details.totalContributionsCents += contribution.amount_cents
          details.fundsLeftCents = details.allocation_amount_cents - details.totalContributionsCents
          return details

      getBuckets: (roundId) ->
        Restangular.one('rounds', roundId).get().then (response) ->
          response.buckets