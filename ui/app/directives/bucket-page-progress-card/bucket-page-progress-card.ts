null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageProgressCard', () ->
  restrict: 'E'
  template: require('./bucket-page-progress-card.html')
  replace: true
  controller: (Dialog, $q, Records, $scope, $state, Toast) ->

    maxAllowableContribution = _.min([$scope.bucket.amountRemaining(), $scope.membership.balance])

    $scope.percentContributed = ->
      ($scope.newContribution.amount || 0) / $scope.bucket.target * 100

    $scope.totalAmountFunded = ->
      parseFloat($scope.bucket.totalContributions) + ($scope.newContribution.amount || 0)

    $scope.normalizeContributionAmount = ->
      if $scope.newContribution.amount > maxAllowableContribution
        $scope.newContribution.amount = +maxAllowableContribution.toFixed(2)

    $scope.submitContribution = ->
      $scope.contributionSubmitted = true
      $scope.newContribution.save()
        .then ->
          membershipPromise = Records.memberships.remote.fetchById($scope.membership.id)
          bucketPromise = Records.buckets.remote.fetchById($scope.bucket.id)
          $q.allSettled([membershipPromise, bucketPromise]).then ->
            $scope.newContribution = {}
            $state.reload()
            Toast.show('You funded a bucket')
        .catch (err) ->
          console.log('err: ', err)

    return
