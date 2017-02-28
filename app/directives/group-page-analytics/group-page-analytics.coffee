null

### @ngInject ###
global.cobudgetApp.directive 'groupPageAnalytics', () ->
    restrict: 'E'
    template: require('./group-page-analytics.html')
    replace: true
    controller: ($scope, $location) ->

     $scope.showBucket = (bucketId) ->
       $location.path("/buckets/#{bucketId}")

      $scope.showArchivedBuckets = ->
        $scope.archivedBucketsShown = true

      $scope.hideArchivedBuckets = ->
        $scope.archivedBucketsShown = false

      return
