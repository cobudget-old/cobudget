null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageProgressCard', () ->
    restrict: 'E'
    template: require('./bucket-page-progress-card.html')
    replace: true
    controller: ($scope, $state, Toast) ->

      maxAllowableContribution = _.min([$scope.bucket.amountRemaining(), $scope.membership.balance()])

      $scope.openFundForm = ->
        $scope.fundFormOpened = true

      $scope.percentContributed = ->
        ($scope.newContribution.amount || 0) / $scope.bucket.target * 100

      $scope.totalAmountFunded = ->
        parseFloat($scope.bucket.totalContributions) + ($scope.newContribution.amount || 0)

      $scope.normalizeContributionAmount = ->
        if $scope.newContribution.amount > maxAllowableContribution
          $scope.newContribution.amount = maxAllowableContribution

      $scope.submitContribution = ->
        $scope.newContribution.save().then ->
          $state.reload()
          Toast.show('You funded a bucket')

      return
