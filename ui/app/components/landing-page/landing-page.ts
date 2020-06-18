/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  url: '/',
  template: require('./landing-page.html'),
  controller(Dialog, LoadBar, $location, Records, $scope, Session, ValidateAndRedirectLoggedInUser) {

    ValidateAndRedirectLoggedInUser();

    $scope.openVirtualTourDialog = () => Dialog.custom({
      template: require('./virtual-tour-dialog.tmpl.html')});

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

  }
};
