module.exports = ($scope) ->
  template: require('./upload-csv-primer-dialog.html')
  scope: $scope
  controller: (Dialog, config, $mdDialog, $scope, $state, $timeout) ->
    $scope.cancel = ->
      $mdDialog.cancel()

    $scope.uploadPath = ->
      "#{config.apiPrefix}/allocations/upload_review?group_id=#{$scope.group.id}"

    $scope.openCSVUploadDialog = ->
      $timeout( ->
        angular.element('.manage-group-funds-page__upload-csv-primer-dialog-hidden-btn input').trigger('click')
      , 100)

    $scope.onCSVUploadSuccess = (response) ->
      people = response.data.data
      $scope.cancel()
      $state.go('review-bulk-allocation', {people: people, groupId: groupId})

    $scope.onCSVUploadError = (response) ->
      # $scope.cancel()
      # Dialog.custom
      #   template: require('./upload-csv-error-dialog.tmpl.html')
      #   scope: $scope
      #   controller: ($scope, $mdDialog) ->
      #     $scope.csvUploadErrors = response.data.errors
      #
      #     $scope.cancel = ->
      #       $mdDialog.cancel()
      #     $scope.tryAgain = ->
      #       $scope.openUploadCSVPrimerDialog()
