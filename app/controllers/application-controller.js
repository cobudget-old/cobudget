/* @ngInject */
global.cobudgetApp.controller('ApplicationController', function ($scope, $modal, $urlRouter, authModel, $http, login) {

  $scope.currentUser = authModel;

  $scope.updateCurrentUser = function () {
    $scope.updateCurrentUserHeaders();
  };

  $scope.updateCurrentUserHeaders = function () {
    var currentUser = $scope.currentUser;
    var defaultHeaders = {
      "Accept": "application/json",
      "X-User-Token": currentUser.accessToken,
      "X-User-Email": currentUser.email,
    };
    $http.defaults.headers.common = defaultHeaders;
  };

  authModel.on("login-success", function () {
    $scope.updateCurrentUser();
    $urlRouter.sync();
  });

  authModel.on("logout-success", function () {
    $scope.updateCurrentUser();
  });

  $scope.updateCurrentUser();

  login.openLogin()
});
