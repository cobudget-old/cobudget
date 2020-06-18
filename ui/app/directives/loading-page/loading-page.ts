// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
cobudgetApp.directive('loadingPage', () => ({
  restrict: 'E',
  scope: {},
  template: require('./loading-page.html'),
  replace: true,

  controller($scope) {

    $scope.loading = false;

    $scope.$on('loading', () => $scope.loading = true);

    return $scope.$on('loaded', () => $scope.loading = false);
  },
}));