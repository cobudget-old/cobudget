`// @ngInject`
angular.module('cobudget').service 'RoundService',  (Restangular, RoundModel, GroupService, ContributionModel) ->

  get: (round_id) ->
    console.log(round_id)
    Restangular.one('rounds', round_id).get()
    .then (round) ->
      new RoundModel(round.plain())

  getLatestRound: (groupId) ->
    GroupService.get(groupId).then (group) ->
      group.latestRound

  getContributorDetails: (roundId, userId) ->
    Restangular.one('rounds', roundId).one('contributors', userId).get().then (details) ->
      ret = {
        allocationAmountCents: details.allocation_amount_cents
        contributions: []
      }
      ret.totalContributionsCents = 0
      for contribution in details.contributions
        ret.contributions.push(new ContributionModel(contribution))
        ret.totalContributionsCents += contribution.amount_cents
      ret.fundsLeftCents = ret.allocationAmountCents - ret.totalContributionsCents

      return ret

  getBuckets: (roundId) ->
    Restangular.one('rounds', roundId).get().then (response) ->
      response.buckets