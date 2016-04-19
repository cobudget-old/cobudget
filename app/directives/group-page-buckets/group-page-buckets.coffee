null

### @ngInject ###
global.cobudgetApp.directive 'groupPageBuckets', () ->
    restrict: 'E'
    template: require('./group-page-buckets.html')
    replace: true
    controller: ($scope, $location) ->

     $scope.showBucket = (bucketId) ->
       $location.path("/buckets/#{bucketId}")

      $scope.showArchivedBuckets = ->
        $scope.archivedBucketsShown = true

      $scope.hideArchivedBuckets = ->
        $scope.archivedBucketsShown = false

      return
