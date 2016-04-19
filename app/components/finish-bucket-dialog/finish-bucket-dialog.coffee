module.exports = (params) ->
  template: require('./finish-bucket-dialog.html')
  scope: params.scope
  controller: (Dialog, LoadBar, $location, $mdDialog, $scope) ->

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.proceed = ->
      $scope.cancel()
      # LoadBar.start()
      # $scope.bucket.finish()
        # .then ->
        # .catch ->
        # .finally ->
        #   LoadBar.stop()
