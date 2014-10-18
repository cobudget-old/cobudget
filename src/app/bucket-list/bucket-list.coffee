angular.module('bucket-list', [])
  .controller 'BucketListCtrl', ($scope, $stateParams, RoundLoader) ->
    $scope.budgetId = $stateParams.budgetId
    
    RoundLoader.getBuckets($stateParams.budgetId).then (buckets) ->
      $scope.buckets = buckets


		
