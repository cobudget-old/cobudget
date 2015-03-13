var _ = require('lodash')
var debug = require('debug')("login:forgot-login")

/* @ngInject */
module.exports = function ($scope, $modalInstance, BaseCollection, AuthService) {

  $scope.user = {};
  $scope.alerts = new BaseCollection();
  
  $scope.submit = function (forgotLogin) {
    $scope.submitted = true;

    AuthService.forgotLogin($scope.user)
    .then(function () {
      $modalInstance.close($scope.user)
    }, function (err) {
      // check for handleable errors
      if (
          err.data && err.data.errors && err.data.errors.email &&
          _.contains(err.data.errors.email, "not found")
        ) {
        forgotLogin.email.$setValidity("notFound", false)
        debug("email not found", $scope.email)
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
