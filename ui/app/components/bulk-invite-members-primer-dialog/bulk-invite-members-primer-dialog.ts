/* eslint-disable
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default params => ({
  template: require('./bulk-invite-members-primer-dialog.html'),
  scope: params.scope,

  controller(Dialog, config, $mdDialog, $scope, $state, $timeout) {
    $scope.cancel = () => $mdDialog.cancel();

    $scope.uploadPath = () => `${config.apiPrefix}/memberships/upload_review?group_id=${$scope.group.id}`;

    $scope.openCSVUploadDialog = () => $timeout( () => angular.element('.bulk-invite-members-primer-dialog__hidden-btn input').trigger('click')
    , 100);

    $scope.onCSVUploadSuccess = function(response) {
      const people = response.data.data;
      $scope.cancel();
      return $state.go('review-bulk-invite-members', {people, groupId: $scope.group.id});
    };

    return $scope.onCSVUploadError = function(response) {
      $scope.cancel();
      const uploadCSVPrimerDialogError = require('./../upload-csv-primer-dialog-error/upload-csv-primer-dialog-error.coffee')({
        scope: $scope,
        response,
        type: 'invite-members',
      });
      return Dialog.open(uploadCSVPrimerDialogError);
    };
  },
});
