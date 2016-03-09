module.exports = (params) ->
    template: require('./upload-csv-primer-dialog-error.html')
    scope: params.scope
    controller: (Dialog, $mdDialog, $scope) ->
      $scope.csvUploadErrors = params.response.data.errors

      $scope.cancel = ->
        $mdDialog.cancel()

      $scope.tryAgain = ->
        uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
          scope: $scope
        })
        Dialog.open(uploadCSVPrimerDialog)
