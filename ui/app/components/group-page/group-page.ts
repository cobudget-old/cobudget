/* eslint-disable
    babel/new-cap,
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
      return global.cobudgetApp.membershipsLoaded;
    },
  },
  url: '/groups/:groupId?tab',
  template: require('./group-page.html'),
  params: {
    firstTimeSeeingGroup: null,
  },
  controller(CurrentUser, Error, LoadBar, $location, Records, $scope, $stateParams, UserCan, $window) {
    LoadBar.start();

    const groupId = parseInt($stateParams.groupId);
    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        if (UserCan.viewGroup(group)) {
          $scope.authorized = true;
          Error.clear();
          $scope.group = group;
          $scope.currentUser = CurrentUser();
          $scope.membership = group.membershipFor(CurrentUser());
          Records.buckets.fetchByGroupId(groupId).then(() => LoadBar.stop());
          return Records.contributions.fetchByGroupId(groupId);
        } else if (CurrentUser().isSuperAdmin) {
          return $window.location.reload();
        } else {
          $scope.authorized = false;
          LoadBar.stop();
          return Error.set('cannot view group');
        }}).catch(function() {
        LoadBar.stop();
        return Error.set('group not found');
    });

  },
};
