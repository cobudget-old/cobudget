module.exports = (params) ->
  template: require('./archive-bucket-dialog.html')
  scope: params.scope
  controller: ($mdDialog, $scope) ->

    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.proceed = ->
      $scope.cancel()
      $scope.archiveBucketAndRedirect()
