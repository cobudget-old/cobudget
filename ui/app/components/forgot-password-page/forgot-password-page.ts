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
export default {
  url: '/forgot_password',
  template: require('./forgot-password-page.html'),
  controller(Dialog, $location, Records, $scope) {

    $scope.formData = {};
    return $scope.requestPassword = () => Records.users.requestPasswordReset($scope.formData)
      .then(res => Dialog.alert({title: 'Help is on the way!', content: 'Go check your email to reset your account.'}).then(() => $location.path('/'))).catch(err => Dialog.alert({title: 'Error', content: 'That email does not exist.'}));
  },
};
