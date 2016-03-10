module.exports = (params) ->
    template: require('./upload-csv-primer-dialog-error.html')
    scope: params.scope
    controller: (Dialog, $mdDialog, $scope) ->
      $scope.csvUploadErrors = params.response.data.errors

      $scope.cancel = ->
        $mdDialog.cancel()

      $scope.tryAgain = ->
        uploadCSVPrimerDialog = require('./../upload-csv-primer-dialog/upload-csv-primer-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(uploadCSVPrimerDialog)
