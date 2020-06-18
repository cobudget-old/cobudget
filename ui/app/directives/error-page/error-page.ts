/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('errorPage', () => ({
  restrict: 'E',
  scope: {},
  template: require('./error-page.html'),
  replace: true,

  controller($scope, $state) {

    $scope.error = null;

    $scope.$on('set error', (e, msg) => $scope.error = msg);

    $scope.$on('clear error', e => $scope.error = null);

    return $scope.back = () => $state.go('landing');
  }
}));
