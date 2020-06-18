// TODO: This file was created by bulk-decaffeinate.
// Sanity-check the conversion and remove this comment.
/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
null;

/* @ngInject */
cobudgetApp.directive('adminToolbar', () => ({
  restrict: 'E',
  template: require('./admin-toolbar.html'),
  replace: true,

  controller($location, $scope, $stateParams) {

    const groupId = parseInt($stateParams.groupId);

    return $scope.cancel = () => $location.path(`/groups/${groupId}`);
  },
}));
