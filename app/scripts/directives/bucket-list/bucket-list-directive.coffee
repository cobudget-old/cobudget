controller = ($rootScope, $scope, Budget) ->
  $rootScope.$watch 'currentBudget', (budget) ->
    return unless budget
    Budget.getBudgetBuckets(budget.id).then (buckets) ->
      $scope.buckets = buckets

window.Cobudget.Directives.BucketList = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/bucket-list/bucket-list.html'
    controller: controller
  }
