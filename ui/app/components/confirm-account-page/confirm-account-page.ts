/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
export default {
  onExit($location) {
    return $location.url($location.path());
  },
  resolve: {
    clearSession(Session) {
      return Session.clear();
    }
  },
  url: '/confirm_account?confirmation_token&setup_group&email&name',
  template: require('./confirm-account-page.html'),
  reloadOnSearch: false,
  controller($scope, $auth, LoadBar, $location, $stateParams, Records, Session, Toast) {
    $scope.confirmationToken = $stateParams.confirmation_token;
    $scope.email = $stateParams.email;
    $scope.name = $stateParams.name;
    $scope.setupGroup = $stateParams.setup_group;
    $scope.formData = [];
    $scope.formData.name = $stateParams.name;

    return $scope.confirmAccount = function(formData) {
      LoadBar.start();
      const params = {
        name: formData.name,
        password: formData.password,
        confirmation_token: $scope.confirmationToken
      };
      return Records.users.confirmAccount(params)
        .then(function(data) {
          const loginParams = { email: data.users[0].email, password: formData.password };
          if ($scope.setupGroup) {
            return Session.create(loginParams).then(() => $location.path("/setup_group"));
          } else {
            return Session.create(loginParams, {redirectTo: 'group'});
          }}).catch(function() {
          Toast.show('Sorry, that confirmation token has expired.');
          return $location.path('/');
      });
    };
  }
};
