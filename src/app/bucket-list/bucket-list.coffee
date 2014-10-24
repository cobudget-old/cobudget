angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader, Round, BudgetLoader, Contribution, AuthService, Restangular, Bucket) ->

    ///Lots of this should be abstracted into a service///

    $scope.current_user_id = AuthService.getCurrentUser().id

    $scope.loadContributorDetails = () ->
      RoundLoader.getContributorDetails($scope.round.id, $scope.currentUser.id).then (details) ->
        $scope.myRoundDetails = details

    $scope.saveContribution = (contribution) ->
      unsaved = _.clone(contribution)
      # remove 'amount_dollars' computed property
      delete unsaved.amount_dollars
      Contribution.save(unsaved).then (saved) ->
        if saved
          contribution.id = saved.id
        $scope.loadContributorDetails()

    $scope.groupId = $stateParams.groupId

    RoundLoader.getLatestRoundId($stateParams.groupId).then (round_id) ->
      Round.get(round_id).then (round) ->
        $scope.round = round
        $scope.loadContributorDetails()

        _.each $scope.round.buckets, (bucket, index) ->
          # get current user's contribution
          my_contribution = Bucket.getMyBucketContribution(bucket, $scope.current_user_id)

          Object.defineProperty(my_contribution, "amount_dollars", {
            get: ->
              this.amount_cents / 100.0
            set: (amount_dollars) ->
              this.amount_cents = amount_dollars * 100
          })

          bucket.my_contribution = my_contribution
          bucket.group_contribution_percentage = bucket.percentage_funded - Bucket.getMyBucketContributionPercentage(bucket, my_contribution)
          bucket.group_contribution_cents = bucket.contribution_total_cents - my_contribution.amount_cents

          $scope.$watch "round.buckets["+index+"].my_contribution.amount_dollars", (amount_dollars) ->
            # compute my_contribution amount versus total percentage
            bucket.my_contribution_percentage = Bucket.getMyBucketContributionPercentage(bucket, my_contribution)

        #Find total cents contributed to round for bucket list sum
        total_cents_contributed = 0
        for bucket in $scope.round.buckets
          total_cents_contributed += bucket.contribution_total_cents

        #Find total round funds for bucket list sum
        round_funds_total_cents = 0
        for allocation in $scope.round.allocations
          round_funds_total_cents += allocation.amount_cents

        $scope.round.total_allocable = round_funds_total_cents / 100
        console.log('round funds total', round_funds_total_cents)
        $scope.round.total_allocated = total_cents_contributed / 100
        $scope.round.time_left_days = 3
        $scope.round.time_left_hours = 72

    BudgetLoader.setBudgetByRoute()

