var _ = require('lodash')
var debug = require('debug')("login:reset-login-modal");

/* @ngInject */
module.exports = function ($scope, authModel, $modalInstance, AlertCollection, AuthService) {

  debug("$scope", $scope)

  $scope.user = {
    resetPasswordToken: authModel.resetPasswordToken,
  };
  $scope.alerts = new AlertCollection();
  
  $scope.submit = function (resetLogin) {
    $scope.submitted = true

    debug("submitted", $scope.user, resetLogin)

    if ($scope.user.password !== $scope.user.passwordConfirmation) {
      resetLogin.passwordConfirmation.$setValidity("match", false);
    } else {
      resetLogin.passwordConfirmation.$setValidity("match", true);
    }

    if (resetLogin.$invalid) {
      debug("invalid", resetLogin);
      return;
    }

    AuthService.resetLogin($scope.user)
    .then(function () {
      $modalInstance.close($scope.user)
    }, function (err) {
      debug("reset login error", err)

      // clear alerts
      $scope.alerts.reset()

      // check for handleable errors
      if (
        err && err.data && err.data.errors &&
        _.contains(
          err.data.errors.resetPasswordToken,
          "is invalid"
        )
      ) {
        $scope.alerts.add({
          type: "danger",
          msg: "Reset Password Token is invalid.",
        })
        return
      }

      // otherwise pass error up
      $modalInstance.dismiss(err)
    });
  };

  $scope.cancel = function () {
    $modalInstance.dismiss(null);
  };
};
