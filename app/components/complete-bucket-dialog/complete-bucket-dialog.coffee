module.exports = (params) ->
  template: require('./complete-bucket-dialog.html')
  scope: params.scope
  controller: (Dialog, LoadBar, $location, $mdDialog, $scope, Toast) ->

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.proceed = ->
      $scope.cancel()
      LoadBar.start()
      $scope.bucket.complete()
        .then ->
          groupId = $scope.bucket.groupId
          Toast.show('Bucket marked as complete!')
          LoadBar.stop()
        .catch ->
          Dialog.alert({title: "Error!"})
          LoadBar.stop()
