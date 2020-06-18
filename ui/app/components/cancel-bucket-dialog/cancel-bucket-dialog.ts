/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default params => ({
  template: require('./cancel-bucket-dialog.html'),
  scope: params.scope,

  controller(Dialog, LoadBar, $location, $mdDialog, $scope) {

    $scope.cancel = () => $mdDialog.cancel();

    return $scope.proceed = function() {
      $scope.cancel();
      LoadBar.start();
      return $scope.bucket.cancel()
        .then(function() {
          const {
            groupId
          } = $scope.bucket;
          return $location.path(`/groups/${groupId}`);}).catch(function() {
          Dialog.alert({title: "Error!"});
          return LoadBar.stop();
      });
    };
  }
});
