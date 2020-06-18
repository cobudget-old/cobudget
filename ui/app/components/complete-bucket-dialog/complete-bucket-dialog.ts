/* eslint-disable
    no-unused-vars,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default params => ({
  template: require('./complete-bucket-dialog.html'),
  scope: params.scope,

  controller(Dialog, LoadBar, $location, $mdDialog, $scope, Toast) {

    $scope.cancel = () => $mdDialog.cancel();

    return $scope.proceed = function() {
      $scope.cancel();
      LoadBar.start();
      return $scope.bucket.complete()
        .then(function() {
          const {
            groupId,
          } = $scope.bucket;
          Toast.show('Bucket marked as complete!');
          return LoadBar.stop();}).catch(function() {
          Dialog.alert({title: 'Error!'});
          return LoadBar.stop();
      });
    };
  },
});
