/* eslint-disable
    babel/new-cap,
    no-undef,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  resolve: {
    userValidated($auth) {
      return $auth.validateUser();
    },
    membershipsLoaded() {
      return cobudgetApp.membershipsLoaded;
    },
  },
  url: '/groups/:groupId/manage_funds',
  template: require('./manage-group-funds-page.html'),
  controller(config, CurrentUser, Dialog, DownloadCSV, Error, LoadBar, Records, $scope, $stateParams, UserCan) {

    LoadBar.start();
    const groupId = parseInt($stateParams.groupId);
    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        LoadBar.stop();
        if (UserCan.manageFundsForGroup(group)) {
          $scope.authorized = true;
          Error.clear();
          $scope.group = group;
          $scope.currentUser = CurrentUser();
          return Records.memberships.fetchByGroupId(groupId);
        } else {
          $scope.authorized = false;
          return Error.set("you can't view this page");
        }}).catch(function() {
        LoadBar.stop();
        return Error.set('group not found');
    });

    $scope.usingSafari = browser.safari;

    $scope.downloadCSV = function() {
      const timestamp = moment().format('YYYY-MM-DD-HH-mm-ss');
      const filename = `${$scope.group.name}-member-data-${timestamp}`;
      const params = {
        url: `${config.apiPrefix}/memberships.csv?group_id=${groupId}`,
        filename,
      };
      return DownloadCSV(params);
    };

    $scope.openUploadCSVPrimerDialog = function() {
      const uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
        scope: $scope,
      });
      return Dialog.open(uploadCSVPrimerDialog);
    };

  },
};
