controller = ($rootScope, $scope, Budget, Bucket) ->
  $rootScope.$watch 'currentBudget', (budget) ->
    return unless budget
    Budget.getBudgetBuckets(budget.id).then (buckets) ->
      $scope.buckets = buckets

  $scope.selectBucket (bucketId) ->
  	Bucket.getBucket(bucketId)

window.Cobudget.Directives.BucketList = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/bucket-list/bucket-list.html'
    controller: controller
  }
