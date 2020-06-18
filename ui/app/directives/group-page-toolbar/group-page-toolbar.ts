// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
cobudgetApp.directive('groupPageToolbar', () => ({
  restrict: 'E',
  template: require('./group-page-toolbar.html'),
  replace: true,

  controller($rootScope, $scope) {

    $scope.openSidenav = () => $rootScope.$broadcast('open sidenav');

    $scope.openAnnouncements = () => $rootScope.$broadcast('open announcements');

  },
}));
