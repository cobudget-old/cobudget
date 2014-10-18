angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader) ->
    $scope.budgetId = $stateParams.budgetId
    RoundLoader.getCurrentRoundId($stateParams.budgetId).then (round_id) ->
      RoundLoader.getBuckets(round_id).then (buckets) ->
        $scope.buckets = buckets


		
