// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default params => ({
  template: require('./upload-csv-primer-dialog-error.html'),
  scope: params.scope,

  controller(Dialog, $mdDialog, $scope) {
    $scope.csvUploadErrors = params.response.data.errors;

    $scope.cancel = () => $mdDialog.cancel();

    return $scope.tryAgain = function() {
      let uploadCSVPrimerDialog;
      if (params.type === 'invite-members') {
        uploadCSVPrimerDialog = require('./../bulk-invite-members-primer-dialog/bulk-invite-members-primer-dialog.coffee')({
          scope: $scope,
        });
      } else if (params.type === 'allocation') {
        uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
          scope: $scope,
        });
      }
      return Dialog.open(uploadCSVPrimerDialog);
    };
  },
});
