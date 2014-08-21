controller=null
`// @ngInject`
controller = ($rootScope, $scope, Budget) ->
  $rootScope.$watch 'currentBudget', (budget) ->
    return unless budget
    Budget.getBudgetBuckets(budget.id).then (buckets) ->
      _.each buckets, (bucket) ->
        bucket.percentage_funded = 20
        bucket.my_allocation_total = 100

      $scope.buckets = buckets

window.Cobudget.Directives.BucketList = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/bucket-list/bucket-list.html'
    controller: controller
  }
