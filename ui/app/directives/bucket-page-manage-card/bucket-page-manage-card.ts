null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageManageCard', () ->
    restrict: 'E'
    template: require('./bucket-page-manage-card.html')
    replace: true
    controller: (Dialog, $scope, $location) ->

      $scope.edit = ->
        $location.path("/buckets/#{$scope.bucket.id}/edit")

      $scope.cancel = ->
        cancelBucketDialog = require('./../../components/cancel-bucket-dialog/cancel-bucket-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(cancelBucketDialog)

      $scope.refund = ->
        refundBucketDialog = require('./../../components/refund-bucket-dialog/refund-bucket-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(refundBucketDialog)

      return
