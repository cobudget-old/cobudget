/* eslint-disable
    babel/new-cap,
    no-undef,
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
global.cobudgetApp.directive('groupPageAnnouncements', () => ({
  restrict: 'E',
  template: require('./group-page-announcements.html'),
  replace: true,

  controller($scope, CurrentUser, Records, $mdSidenav, $location) {

    $scope.$on('open announcements', function() {
      $mdSidenav('right').open();
      return $mdSidenav('right').onClose(function() {
        if (($scope.announcements.length > 0) && ($scope.unseenAnnoucements.length > 0)) {
          const mostRecentDate = $scope.announcements[0].createdAt;
          return Records.announcements.seen({last_seen: mostRecentDate}).then(function() {
            const allAnnouncements = Records.announcements.find({});
            $scope.announcements = _.map(allAnnouncements, function(announcement) {
              announcement.seen = true;
              return announcement;
            });
            return $scope.unseenAnnoucements = [];});
        }});
  });

    $scope.currentUser = CurrentUser();
    $scope.announcements = Records.announcements.find({});
    $scope.unseenAnnoucements = Records.announcements.find({seen:{ $eq : false }});

  },
}));
