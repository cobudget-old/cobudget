angular.module('auth').factory('AuthService', function ($rootScope, $http, $cookieStore, AUTH_EVENTS, config) {
  var authService = {};

  authService.login = function (credentials) {
    return $http
      .post(config.apiEndpoint + '/auth/sign_in.json', credentials)
      .then(function (res) {
        $cookieStore.put('user', res.data.user);
        $rootScope.$broadcast(AUTH_EVENTS.loginSuccess);
        return res.data.user;
      }, function(res) {
        $rootScope.$broadcast(AUTH_EVENTS.loginFailed);
      });
  };

  authService.getCurrentUser = function () {
    return $cookieStore.get('user')
  };

  authService.logout = function () {
    $cookieStore.remove('user');
    $rootScope.$broadcast(AUTH_EVENTS.logoutSuccess);
  };

  return authService;
});
