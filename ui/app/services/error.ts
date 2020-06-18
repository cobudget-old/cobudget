/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.factory('Error', function($rootScope) {
  let Error;
  return new (Error = class Error {
    set(msg) {
      return $rootScope.$broadcast('set error', msg);          
    }

    clear() {
      return $rootScope.$broadcast('clear error');
    }
  });
});