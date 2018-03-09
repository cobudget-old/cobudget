module.exports = (params) ->
  template: require('./refund-bucket-dialog.html')
  scope: params.scope
  controller: (Dialog, LoadBar, $location, $mdDialog, $scope, Toast) ->

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.proceed = ->
      $scope.cancel()
      LoadBar.start()
      $scope.bucket.cancel()
        .then ->
          groupId = $scope.bucket.groupId
          Toast.show('Bucket refunded!')
          LoadBar.stop()
        .catch ->
          Dialog.alert({title: "Error!"})
          LoadBar.stop()
