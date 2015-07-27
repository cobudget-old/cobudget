require('angular-cookies');

/* @ngInject */
module.exports = angular.module('cobudget.auth', [
  'ngCookies',
])
.factory('AuthModel', require('./auth-model'))
.factory('authModel', function (AuthModel) {
  return new AuthModel();
})
.service('authCookie', require('./auth-cookie'))
.service('AuthService', require('./auth-service'))
;

require('./interceptor');
