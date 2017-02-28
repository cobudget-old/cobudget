null

### @ngInject ###
global.cobudgetApp.directive 'groupPageAnalytics', () ->
    restrict: 'E'
    template: require('./group-page-analytics.html')
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
