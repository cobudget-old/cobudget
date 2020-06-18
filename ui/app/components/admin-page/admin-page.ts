/* eslint-disable
    babel/new-cap,
    no-shadow,
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
  url: '/groups/:groupId/settings',
  template: require('./admin-page.html'),
  controller(CurrentUser, Error, Dialog, $location, Records, $scope, UserCan, Toast, $stateParams, Currencies) {

    const groupId = parseInt($stateParams.groupId);

    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        if (CurrentUser().isAdminOf(group)) {
          $scope.authorized = true;
          Error.clear();
          return $scope.group = group;
        } else {
          $scope.authorized = false;
          return Error.set("you can't view this page");
        }}).catch(() => Error.set('group not found'));

    $scope.currencies = Currencies();

    $scope.updateGroup = () => $scope.group.save()
      .then(function() {
        Toast.show('You updated ' + $scope.group.name);
        return $scope.cancel();
    });

    $scope.viewGroup = groupId => $location.path(`/groups/${groupId}`);

    $scope.cancel = () => $location.path(`/groups/${groupId}`);

    $scope.attemptCancel = function(adminPageForm) {
      if (adminPageForm.$dirty) {
        return Dialog.confirm({title: 'Discard unsaved changes?'})
          .then(() => $scope.cancel());
      } else {
        return $scope.cancel();
      }
    };

  },
};
