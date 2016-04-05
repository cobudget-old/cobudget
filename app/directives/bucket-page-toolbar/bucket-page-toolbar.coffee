null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageToolbar', () ->
    restrict: 'E'
    template: require('./bucket-page-toolbar.html')
    replace: true
    controller: (Dialog, $location, $scope, Toast) ->

      $scope.edit = ->
        $location.path("/buckets/#{$scope.bucket.id}/edit")

      $scope.userCanEditBucket = ->
        $scope.bucket && $scope.userCanStartFunding()

      $scope.archive = ->
        if $scope.bucket.status == 'live'
          archiveBucketDialog = require('./../../components/archive-bucket-dialog/archive-bucket-dialog.coffee')({
            scope: $scope
          })
          Dialog.open(archiveBucketDialog)
        else
          $scope.bucket.archive()
          groupId = $scope.bucket.groupId
          $location.path("/groups/#{groupId}")

      return
