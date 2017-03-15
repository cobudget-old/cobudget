null

### @ngInject ###
global.cobudgetApp.directive 'groupPageStats', () ->
    restrict: 'E'
    template: require('./group-page-stats.html')
    replace: true
    controller: ($scope, $location, Records) ->

      $scope.showBucket = (bucketId) ->
        $location.path("/buckets/#{bucketId}")

      Records.memberships.fetchByGroupId($scope.group.id).then ->
        $scope.fundersLoaded = true

      $scope.showArchivedBuckets = ->
        $scope.archivedBucketsShown = true

      $scope.hideArchivedBuckets = ->
        $scope.archivedBucketsShown = false

      return
