null

### @ngInject ###
global.cobudgetApp.directive 'groupPageSidenav', () ->
    restrict: 'E'
    template: require('./group-page-sidenav.html')
    replace: true
    controller: ($scope, CurrentUser, $mdSidenav, $location, Toast) ->

      $scope.$on 'open sidenav', ->
        $mdSidenav('left').open()

      $scope.accessibleGroups = ->
        CurrentUser() && CurrentUser().groups()

      $scope.redirectToGroupPage = (groupId) ->
        if $scope.group.id == parseInt(groupId)
          $mdSidenav('left').close()
        else
          $location.path("/groups/#{groupId}")

      return