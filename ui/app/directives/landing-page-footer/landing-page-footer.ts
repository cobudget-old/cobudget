// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
global.cobudgetApp.directive('landingPageFooter', () => ({
  restrict: 'E',
  template: require('./landing-page-footer.html'),
  replace: true,

  controller($location, $scope) {

    $scope.redirectToLoginPage = () => $location.path('/login');

    $scope.redirectToResourcesPage = () => $location.path('/about');

    $scope.redirectToAboutPage = () => $location.path('/about');

  },
}));
