/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default params => ({
  template: require('./finish-bucket-dialog.html'),
  scope: params.scope,

  controller(Dialog, LoadBar, $location, $mdDialog, $scope, Toast) {

    $scope.cancel = () => $mdDialog.cancel();

    return $scope.proceed = function() {
      LoadBar.start();
      $scope.cancel();
      params = {
        bucket: {
          status: 'funded'
        }
      };
      return $scope.bucket.remote.update($scope.bucket.id, params)
        .then(function() {
          LoadBar.stop();
          return Toast.show('Funding Accepted!');}).catch(function() {
          LoadBar.stop();
          return Dialog.alert({title: "Error!"});
      });
    };
  }
});
