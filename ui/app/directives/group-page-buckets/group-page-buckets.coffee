null

### @ngInject ###
global.cobudgetApp.directive 'groupPageBuckets', () ->
    restrict: 'E'
    template: require('./group-page-buckets.html')
    replace: true
    controller: ($scope, $location) ->

      $scope.showBucket = (bucketId) ->
        $location.path("/buckets/#{bucketId}")

      $scope.showCompletedBuckets = ->
        $scope.completedBucketsShown = true

      $scope.hideCompletedBuckets = ->
        $scope.completedBucketsShown = false

      $scope.showCancelledBuckets = ->
        $scope.cancelledBucketsShown = true

      $scope.hideCancelledBuckets = ->
        $scope.cancelledBucketsShown = false

      return
