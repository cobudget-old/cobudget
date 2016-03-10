module.exports = (params) ->
    template: require('./upload-csv-primer-dialog-error.html')
    scope: params.scope
    controller: (Dialog, $mdDialog, $scope) ->
      $scope.csvUploadErrors = params.response.data.errors

      $scope.cancel = ->
        $mdDialog.cancel()

      $scope.tryAgain = ->
        if params.type == 'invite-members'
          uploadCSVPrimerDialog = require('./../bulk-invite-members-primer-dialog/bulk-invite-members-primer-dialog.coffee')({
            scope: $scope
          })
        else if params.type == 'allocation'
          uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
            scope: $scope
          })
        Dialog.open(uploadCSVPrimerDialog)
