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
      return cobudgetApp.membershipsLoaded;
    },
  },
  url: '/buckets/:bucketId',
  template: require('./bucket-page.html'),
  controller(CurrentUser, Error, LoadBar, $location, Records, $scope, $stateParams, Toast, UserCan, $window) {

    LoadBar.start();
    $scope.windowWidth = $window.innerWidth;
    $scope.xsWidth = 768;
    const bucketId = parseInt($stateParams.bucketId);
    Records.buckets.findOrFetchById(bucketId)
      .then(function(bucket) {
        if (UserCan.viewBucket(bucket)) {
          $scope.authorized = true;
          Error.clear();
          $scope.currentUser = CurrentUser();
          $scope.bucket = bucket;
          $scope.group = bucket.group();
          $scope.membership = $scope.group.membershipFor(CurrentUser());
          Records.contributions.fetchByBucketId(bucketId).then(function() {
            $scope.contributions = $scope.bucket.contributions();
            $window.scrollTo(0,0);
            return LoadBar.stop();
          });
          return Records.comments.fetchByBucketId(bucketId);
        } else {
          $scope.authorized = false;
          LoadBar.stop();
          return Error.set('cannot view bucket');
        }}).catch(function() {
        LoadBar.stop();
        return Error.set('bucket not found');
    });

    $scope.newContribution = Records.contributions.build({bucketId});

    $scope.back = function() {
      Toast.hide();
      return $location.path(`/groups/${$scope.group.id}`);
    };

    $scope.userCanManageBucket = () => $scope.bucket && !$scope.bucket.isComplete() && !$scope.bucket.isCancelled() && 
    ($scope.membership.isAdmin || ($scope.bucket.author().id === $scope.membership.member().id));

  },
};
