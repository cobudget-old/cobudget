/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('adminToolbar', () => ({
  restrict: 'E',
  template: require('./admin-toolbar.html'),
  replace: true,

  controller($location, $scope, $stateParams) {

    const groupId = parseInt($stateParams.groupId);

    return $scope.cancel = () => $location.path(`/groups/${groupId}`);
  }
}));
