angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundService, BudgetLoader, ContributionService, AuthService, BucketService) ->

    ///Lots of this should be abstracted into a service///

    $scope.currentUserId = AuthService.getCurrentUser().id

    $scope.loadContributorDetails = () ->
      RoundService.getContributorDetails($scope.round.id, $scope.currentUser.id).then (details) ->
        $scope.myRoundDetails = details

    $scope.saveContribution = (contribution) ->
      contribution.save(ContributionService).then ->
        $scope.loadContributorDetails()

    $scope.groupId = $stateParams.groupId

    RoundService.getLatestRound($stateParams.groupId).then (round) ->
      $scope.round = round
      $scope.loadContributorDetails()

      _.each round.buckets, (bucket, index) ->
        # get current user's contribution
        myContribution = bucket.getMyContribution($scope.currentUserId)
        bucket.getMyContributionPercentage()
        bucket.getGroupContribution()

        $scope.$watch "round.buckets["+index+"].myContribution.amountDollars", (amountDollars) ->
          # compute myContribution amount versus total percentage
          bucket.getMyContributionPercentage(myContribution)

      #Find total cents contributed to round for bucket list sum
      totalCentsContributed = 0
      for bucket in $scope.round.buckets
        totalCentsContributed += bucket.contributionTotalCents

      #Find total round funds for bucket list sum
      roundFundsTotalCents = 0
      for allocation in $scope.round.allocations
        roundFundsTotalCents += allocation.amountCents

      $scope.round.totalAllocable = roundFundsTotalCents / 100
      console.log('round funds total', roundFundsTotalCents)
      $scope.round.totalAllocated = totalCentsContributed / 100
      $scope.round.timeLeftDays = 3
      $scope.round.timeLeftHours = 72

    BudgetLoader.setBudgetByRoute()

