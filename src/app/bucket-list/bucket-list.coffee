angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader, Round, BudgetLoader, Contribution, AuthService) ->

    ///Lots of this should be abstracted into a service///

    $scope.groupId = $stateParams.groupId
    RoundLoader.getLatestRoundId($stateParams.groupId).then (round_id) ->
      Round.get(round_id).then (round) ->
        $scope.round =  round

        _.each $scope.round.buckets, (bucket, index) ->
          # get current user's contribution
          bucket.my_contribution = _.find(bucket.contributions, (contribution) ->
              # if a contribution from this user already exists
              contribution.user.id == AuthService.getCurrentUser().id
            ) or { #create an empty contribution
              user_id: AuthService.getCurrentUser().id
              bucket_id : bucket.id
              amount_cents: 0
            }
          
          $scope.$watch "round.buckets["+index+"].my_contribution.amount_cents", (amount_cents) ->
            my_contribution = $scope.round.buckets[index].my_contribution 
            #console.log("my contribution", my_contribution)

        $scope.saveContribution = (contribution) ->
          Contribution.save(contribution)

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


