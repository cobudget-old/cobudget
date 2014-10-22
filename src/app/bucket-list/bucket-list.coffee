angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader, Round, BudgetLoader) ->
    $scope.groupId = $stateParams.groupId
    RoundLoader.getLatestRoundId($stateParams.groupId).then (round_id) ->
      RoundLoader.getBuckets(round_id).then (buckets) ->
        $scope.buckets = buckets
        
        ///Lots of this should be abstracted into a service///
        
        Round.get(round_id).then (round) ->
          $scope.round = round

          #Find total cents contributed
          total_cents_contributed = 0
          for bucket in $scope.round.buckets
            total_cents_contributed += bucket.contribution_total_cents

          #Find total round funds
          round_funds_total_cents = 0
          for allocation in $scope.round.allocations
            round_funds_total_cents += allocation.amount_cents

          $scope.round.total_allocable = round_funds_total_cents / 100
          console.log('round funds total', round_funds_total_cents)
          $scope.round.total_allocated = total_cents_contributed / 100
          $scope.round.time_left_days = 3
          $scope.round.time_left_hours = 72

    BudgetLoader.setBudgetByRoute()

