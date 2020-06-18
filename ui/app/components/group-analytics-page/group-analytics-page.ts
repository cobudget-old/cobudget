// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
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
  url: '/groups/:groupId/analytics',
  template: require('./group-analytics-page.html'),
  controller(config, CurrentUser, Error, $http, Records, $scope, $state, $stateParams, UserCan) {

    const groupId = parseInt($stateParams.groupId);
    Records.groups.findOrFetchById(groupId)
      .then(function(group) {
        if (UserCan.viewGroup(group)) {
          $scope.authorized = true;
          Error.clear();
          return $http.get(config.apiPrefix + `/groups/${groupId}/analytics`)
            .then(function(res) {
              $scope.data = res.data;
              return $scope.dataLoaded = true;
          });
        } else {
          $scope.authorized = false;
          return Error.set("you can't view this page");
        }
    });

    $scope.back = () => $state.go('group', {groupId});

  },
};
