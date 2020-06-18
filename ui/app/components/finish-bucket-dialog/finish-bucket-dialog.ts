module.exports = (params) ->
  template: require('./finish-bucket-dialog.html')
  scope: params.scope
  controller: (Dialog, LoadBar, $location, $mdDialog, $scope, Toast) ->

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.proceed = ->
      LoadBar.start()
      $scope.cancel()
      params =
        bucket:
          status: 'funded'
      $scope.bucket.remote.update($scope.bucket.id, params)
        .then ->
          LoadBar.stop()
          Toast.show('Funding Accepted!')
        .catch ->
          LoadBar.stop()
          Dialog.alert({title: "Error!"})
