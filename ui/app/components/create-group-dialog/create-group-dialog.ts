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
  template: require('./create-group-dialog.html'),
  scope: params.scope,

  controller(Dialog, $mdDialog, $scope, $window, $location, LoadBar, Records, Session) {

    $scope.startGroup = function() {
      $location.hash('');
      LoadBar.start();
      const newUser = Records.users.build($scope.formData);
      return newUser.save()
        .then(userData => Session.create(userData, {redirectTo: 'group setup'})).catch(function(err) {
          LoadBar.stop();
          return $location.path('/login').search({setup_group: true, email: newUser.email});
      });
    };

    return $scope.cancel = () => $mdDialog.cancel();
  },
});
