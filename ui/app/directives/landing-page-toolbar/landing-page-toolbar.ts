/* eslint-disable
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
cobudgetApp.directive('landingPageToolbar', () => ({
  restrict: 'E',
  template: require('./landing-page-toolbar.html'),
  replace: true,

  controller($location, $scope, $anchorScroll, Dialog) {

    $scope.createGroupDialog = function(membership) {
      const createGroupDialog = require('./../../components/create-group-dialog/create-group-dialog.coffee')({
        scope: $scope,
      });
      return Dialog.open(createGroupDialog);
    };

    $scope.scrollTo = function(id) {
      $location.hash(id);
      return $anchorScroll();
    };

    $scope.redirectToLoginPage = () => $location.path('/login');

    $scope.redirectToHomePage = () => $location.path('/');

    $scope.redirectToHomePageCreateGroup = function() {
      $location.path('/');
      return $location.hash('createGroup');
    };

    $scope.redirectToHomePageTour = function() {
      $location.path('/');
      return $location.hash('tour');
    };

    $scope.redirectToHomePageStudies = function() {
      $location.path('/');
      return $location.hash('studies');
    };

    $scope.redirectToHomePagePricing = function() {
      $location.path('/');
      return $location.hash('pricing');
    };

    $scope.redirectToCaseStudiesPage = () => $location.path('/case-studies');

    $scope.redirectToServicesPage = function() {
      $location.hash('');
      return $location.path('/services');
    };

    $scope.redirectToAboutPage = () => $location.path('/about');

  },
}));
