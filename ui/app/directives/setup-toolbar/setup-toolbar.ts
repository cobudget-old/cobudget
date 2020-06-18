/* eslint-disable
    babel/new-cap,
*/
// TODO: This file was created by bulk-decaffeinate.
// Fix any style issues and re-enable lint.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('setupToolbar', () => ({
  restrict: 'E',
  template: require('./setup-toolbar.html'),
  replace: true,

  controller(CurrentUser, $location, $scope) {

    $scope.currentUser = CurrentUser();

    $scope.redirectToLoginPage = () => $location.path('/login');

  },
}));
