/* eslint-disable
    babel/new-cap,
    no-unused-vars,
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
cobudgetApp.directive('groupPageSidenav', () => ({
  restrict: 'E',
  template: require('./group-page-sidenav.html'),
  replace: true,

  controller($scope, $state, CurrentUser, $mdSidenav, $location, Toast) {

    $scope.$on('open sidenav', () => $mdSidenav('left').open());

    $scope.accessibleGroups = () => CurrentUser() && CurrentUser().groups();

    $scope.redirectToGroupPage = function(groupId) {
      if (($state.current.name === 'group') && ($scope.group.id === parseInt(groupId))) {
        return $mdSidenav('left').close();
      } else {
        return $location.path(`/groups/${groupId}`);
      }
    };

    $scope.redirectToGroupSetupPage = () => $location.path('/setup_group');

  },
}));
