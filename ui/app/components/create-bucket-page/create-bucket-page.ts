/* eslint-disable
    babel/new-cap,
    no-unused-vars,
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
  url: '/buckets/new?group_id',
  template: require('./create-bucket-page.html'),
  reloadOnSearch: false,
  controller(config, CurrentUser, Error, $location, Records, $scope, $stateParams, Toast, $window) {
    $scope.accessibleGroups = CurrentUser().groups();
    $scope.bucket = Records.buckets.build({groupId: $stateParams.group_id});

    if ($scope.accessibleGroups.length === 1) {
      $scope.bucket.groupId = CurrentUser().primaryGroup().id;
    }

    $scope.cancel = function() {
      let groupId;
      $location.search('group_id', null);
      if ($scope.bucket.groupId) {
        ({
          groupId,
        } = $scope.bucket);
      } else {
        groupId = CurrentUser().primaryGroup().id;
      }

      return $location.path(`/groups/${groupId}`);
    };

    return $scope.done = function() {
      $scope.formSubmitted = true;
      if ($scope.bucketForm.$valid) {
        return $scope.bucket.save().then(function(data) {
          $location.search('group_id', null);
          const bucketId = data.buckets[0].id;
          $location.path(`/buckets/${bucketId}`);
          return Toast.show('You drafted a new bucket');
        });
      }
    };
  },
};
