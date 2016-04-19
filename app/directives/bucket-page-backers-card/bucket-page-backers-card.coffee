null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageBackersCard', () ->
    restrict: 'E'
    template: require('./bucket-page-backers-card.html')
    replace: true
    scope:
      contributions: '='
      currentUser: '='
    controller: ($scope) ->
      groupedContributions = _.groupBy $scope.contributions, 'userId'

      $scope.backers = _.map groupedContributions, (contributions) ->
        callback = (sum, contribution) ->
          sum + contribution.amount
        totalContributionAmount = _.reduce contributions, callback, 0
        {id: contributions[0].user().id, name: contributions[0].user().name, contributionAmount: totalContributionAmount}

      return
