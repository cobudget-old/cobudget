null

### @ngInject ###
global.cobudgetApp.directive 'groupPageAnnouncements', () ->
    restrict: 'E'
    template: require('./group-page-announcements.html')
    replace: true
    controller: ($scope, $state, CurrentUser, Records, $mdSidenav, $location, Toast) ->

      $scope.$on 'open announcements', ->
        $mdSidenav('right').open()

      $scope.$on 'open announcements', ->
        $mdSidenav('right').open()

      $scope.accessibleGroups = ->
        CurrentUser() && CurrentUser().groups()

      $scope.redirectToGroupPage = (groupId) ->
        if $state.current.name == 'group' && $scope.group.id == parseInt(groupId)
          $mdSidenav('right').close()
        else
          $location.path("/groups/#{groupId}")

      $scope.currentUser = CurrentUser()
      $scope.announcements = Records.announcements.find({})
      $scope.activeAnnoucements = Records.announcements.find({'seen':{ '$eq' : null }})

      $scope.redirectToGroupSetupPage = ->
        $location.path('/setup_group')

      return
