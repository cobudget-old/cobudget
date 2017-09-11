null

### @ngInject ###
global.cobudgetApp.directive 'groupPageAnnouncements', () ->
    restrict: 'E'
    template: require('./group-page-announcements.html')
    replace: true
    controller: ($scope, CurrentUser, Records, $mdSidenav, $location) ->

      $scope.$on 'open announcements', ->
        $mdSidenav('right').open()
        $mdSidenav('right').onClose ->
          if $scope.announcements.length > 0 && $scope.unseenAnnoucements.length > 0
            mostRecentDate = $scope.announcements[0].createdAt
            Records.announcements.seen({last_seen: mostRecentDate}).then ->
              allAnnouncements = Records.announcements.find({})
              $scope.announcements = _.map allAnnouncements, (announcement) ->
                announcement.seen = true
                announcement
              $scope.unseenAnnoucements = []

      $scope.currentUser = CurrentUser()
      $scope.announcements = Records.announcements.find({})
      $scope.unseenAnnoucements = Records.announcements.find({'seen':{ '$eq' : false }})

      return
