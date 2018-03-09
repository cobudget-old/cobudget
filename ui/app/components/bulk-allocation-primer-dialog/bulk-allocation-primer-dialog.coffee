module.exports = (params) ->
  template: require('./bulk-allocation-primer-dialog.html')
  scope: params.scope
  controller: (Dialog, config, $mdDialog, $scope, $state, $timeout) ->
    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.uploadPath = ->
      "#{config.apiPrefix}/allocations/upload_review?group_id=#{$scope.group.id}"

    $scope.openCSVUploadDialog = ->
      $timeout( ->
        angular.element('.bulk-allocation-primer-dialog__hidden-btn input').trigger('click')
      , 100)

    $scope.onCSVUploadSuccess = (response) ->
      people = response.data.data
      $scope.cancel()
      $state.go('review-bulk-allocation', {people: people, groupId: $scope.group.id})

    $scope.onCSVUploadError = (response) ->
      $scope.cancel()
      uploadCSVPrimerDialogError = require('./../upload-csv-primer-dialog-error/upload-csv-primer-dialog-error.coffee')({
        scope: $scope,
        response: response,
        type: 'allocation'
      })
      Dialog.open(uploadCSVPrimerDialogError)
