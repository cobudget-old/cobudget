var debug = require('debug')('login:login-controller');

/* @ngInject */
module.exports = function ($scope, $modalInstance, AlertCollection, AuthService, login) {

  $scope.user = {};
  $scope.alerts = new AlertCollection();

  $scope.submit = function (loginForm) {
    $scope.submitted = true

    if (loginForm.$invalid) {
      return;
    }
    debug("logging in", $scope.user);

    AuthService.login($scope.user)
    .then(function () {
      debug("logged in");

      $modalInstance.close();
    }, function (err) {
      debug("error logging in", err);
      
      // reset alerts
      $scope.alerts.reset()

      // check for handleable errors
      if (
        err && err.data &&
        err.data.error === "Invalid email or password"
      ) {
        $scope.alerts.add({
          type: "danger",
          msg: err.data.error,
        })
        return
      }

      $modalInstance.dismiss(err);
    })
  };

  $scope.cancel = function () {
    debug("cancel");
    $modalInstance.dismiss(null)
  };

  $scope.forgotLogin = function () {
    debug("open forgot login modal");
    login.openForgotLogin();
  };

}
