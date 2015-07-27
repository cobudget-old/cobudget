/* @ngInject */
module.exports = angular.module('cobudget.auth')
.factory('AuthInterceptor', function ($q, authModel) {
  return {
    responseError: function (response) {
      var eventNames = {
        401: "not-authenticated",
        403: "not-authorized",
        419: "session-timeout",
        440: "session-timeout",
      };

      var responseEvent = eventNames[response.status];

      authModel.trigger(responseEvent, response);

      return $q.reject(response);
    },
  };
})
.config(function ($httpProvider) {
  $httpProvider.interceptors.push([
    '$injector',
    function ($injector) {
      return $injector.get('AuthInterceptor');
    },
  ]);
});
