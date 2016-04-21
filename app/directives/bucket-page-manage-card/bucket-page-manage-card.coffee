null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageManageCard', () ->
    restrict: 'E'
    template: require('./bucket-page-manage-card.html')
    replace: true
    controller: (Dialog, $scope, $location) ->

      $scope.edit = ->
        $location.path("/buckets/#{$scope.bucket.id}/edit")

      $scope.archive = ->
        archiveBucketDialog = require('./../../components/archive-bucket-dialog/archive-bucket-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(archiveBucketDialog)

      $scope.finish = ->
        finishBucketDialog = require('./../../components/finish-bucket-dialog/finish-bucket-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(finishBucketDialog)

      return
