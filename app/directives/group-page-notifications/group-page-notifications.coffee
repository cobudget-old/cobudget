null

### @ngInject ###
global.cobudgetApp.directive 'groupPageNotifications', () ->
    restrict: 'E'
    template: require('./group-page-notifications.html')
    replace: true
    controller: ($scope, $state, CurrentUser, $mdSidenav, $location, Toast) ->

      $scope.$on 'open notifications', ->
        $mdSidenav('right').open()

      $scope.$on 'open notifications', ->
        $mdSidenav('right').open()

      $scope.accessibleGroups = ->
        CurrentUser() && CurrentUser().groups()

      $scope.redirectToGroupPage = (groupId) ->
        if $state.current.name == 'group' && $scope.group.id == parseInt(groupId)
          $mdSidenav('right').close()
        else
          $location.path("/groups/#{groupId}")

      $scope.redirectToGroupSetupPage = ->
        $location.path('/setup_group')

      return
