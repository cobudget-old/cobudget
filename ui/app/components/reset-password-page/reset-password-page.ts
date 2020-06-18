/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  url: '/reset_password?reset_password_token',
  template: require('./reset-password-page.html'),
  reloadOnSearch: false,
  controller(Dialog, LoadBar, $location, Records, $scope, Session, $stateParams, Toast) {

    $scope.formData = {};
    const resetPasswordToken = $stateParams.reset_password_token;

    return $scope.resetPassword = function() {
      LoadBar.start();
      const {
        password
      } = $scope.formData;
      const {
        confirmPassword
      } = $scope.formData;
      $scope.formData = {};
      if (password === confirmPassword) {
        $location.search('reset_password_token', null);
        const requestParams = {
          password,
          confirm_password: confirmPassword,
          reset_password_token: resetPasswordToken
        };
        return Records.users.resetPassword(requestParams)
          .then(function(res) {
            const loginParams = {email: res.users[0].email, password};
            return Session.create(loginParams, {redirectTo: 'group'});}).catch(function(err) {
            Toast.show('Your reset password token has expired, please request another');
            $location.path('/forgot_password');
            return LoadBar.stop();
        });
      } else {
        LoadBar.stop();
        return Dialog.alert({title: 'Error!', content: 'Passwords must match.'});
      }
    };
  }
};
