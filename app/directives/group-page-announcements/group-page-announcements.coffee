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
          console.log 'closing'
          mostRecentDate = $scope.announcements[0].createdAt
          Records.announcements.seen({last_seen: mostRecentDate}).then ->
            # $scope.activeAnnoucements = Records.announcements.find({'seen':{ '$eq' : null }})
            # $scope.activeAnnoucements[0].seen = 'hi'
            # Records.annoucements.find({'seen':{ '$eq' : null }})
            console.log 'hi'
            # $scope.announcements = []

      # $mdSidenav('right').onClose() = ->
      #   console.log 'closing'


      $scope.currentUser = CurrentUser()
      $scope.announcements = Records.announcements.find({})
      $scope.activeAnnoucements = Records.announcements.find({'seen':{ '$eq' : null }})

      return
