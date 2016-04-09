null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageToolbar', () ->
    restrict: 'E'
    template: require('./bucket-page-toolbar.html')
    replace: true
    controller: (Dialog, LoadBar, $location, $scope, Toast) ->

      $scope.edit = ->
        $location.path("/buckets/#{$scope.bucket.id}/edit")

      $scope.userCanEditBucket = ->
        $scope.bucket && !$scope.bucket.isArchived() && $scope.userCanStartFunding()

      $scope.archive = ->
        archiveBucketDialog = require('./../../components/archive-bucket-dialog/archive-bucket-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(archiveBucketDialog)

      return
