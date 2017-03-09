null

### @ngInject ###
global.cobudgetApp.directive 'bucketPageStatusCard', () ->
    restrict: 'E'
    template: require('./bucket-page-status-card.html')
    replace: true
    controller: ($scope, Toast, Dialog) ->

      $scope.openForFunding = ->
        if $scope.bucket.target
          $scope.bucket.openForFunding().then ->
            $scope.back()
            Toast.showWithRedirect('You launched a bucket for funding', "/buckets/#{$scope.bucket.id}")
        else
          Dialog.alert
            title: 'hi friend ~~'
            content: 'an estimated funding target must be specified before funding starts'
            ok: 'oh, ok!'

      $scope.paid = ->
        paidBucketDialog = require('./../../components/paid-bucket-dialog/paid-bucket-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(paidBucketDialog)
