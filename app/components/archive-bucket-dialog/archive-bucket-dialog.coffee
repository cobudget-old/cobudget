module.exports = (params) ->
  template: require('./archive-bucket-dialog.html')
  scope: params.scope
  controller: (Dialog, LoadBar, $location, $mdDialog, $scope) ->

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.proceed = ->
      $scope.cancel()
      LoadBar.start()
      $scope.bucket.archive()
        .then ->
          groupId = $scope.bucket.groupId
          $location.path("/groups/#{groupId}")
        .catch ->
          Dialog.alert({title: "Error!"})
          LoadBar.stop()
