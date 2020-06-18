/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  url: '/login',
  template: require('./login-page.html'),
  controller($auth, Dialog, Error, LoadBar, $location, Records, $scope, Session, ValidateAndRedirectLoggedInUser, $window) {

    ValidateAndRedirectLoggedInUser().then(() => $scope.authorized = true);

    $scope.formData = {};
    const {
      email
    } = $location.search();
    const setupGroup = $location.search().setup_group;

    if (email) {
      $location.search('email', null);
      $scope.formData.email = email;
    }

    $scope.login = function(formData) {
      LoadBar.start();
      const redirectTo = setupGroup ? 'group setup' : 'group';
      return Session.create(formData, {redirectTo});
    };

    $scope.visitForgotPasswordPage = () => $location.path('/forgot_password');

    $scope.openFeedbackForm = () => $window.location.href = 'https://docs.google.com/forms/d/1-_zDQzdMmq_WndQn2bPUEW2DZQSvjl7nIJ6YkvUcp0I/viewform?usp=send_form';

  }
};
