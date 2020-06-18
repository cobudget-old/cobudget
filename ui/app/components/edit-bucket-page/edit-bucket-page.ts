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
  url: '/buckets/:bucketId/edit',
  template: require('./edit-bucket-page.html'),
  controller(Error, $location, Records, $scope, $stateParams, Toast, UserCan) {

    const bucketId = parseInt($stateParams.bucketId);

    Records.buckets.findOrFetchById(bucketId)
      .then(function(bucket) {
        if (UserCan.editBucket(bucket)) {
          $scope.authorized = true;
          Error.clear();
          return $scope.bucket = bucket;
        } else {
          $scope.authorized = false;
          return Error.set('cannot edit bucket');
        }}).catch(() => Error.set('bucket not found'));

    $scope.cancel = () => $location.path(`/buckets/${bucketId}`);

    return $scope.done = function(bucketForm) {
      if (bucketForm.$valid) {
        $scope.bucket.save();
        Toast.show('Your edits have been saved');
        return $scope.cancel();
      }
    };
  },
};
