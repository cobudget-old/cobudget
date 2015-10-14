null

### @ngInject ###
global.cobudgetApp.directive 'sidenav', () ->
    restrict: 'E'
    template: require('./sidenav.html')
    replace: true
    controller: ($scope, CurrentUser, $mdSidenav, $location) ->

      $scope.$on 'open sidenav', ->
        $mdSidenav('left').open()

      $scope.accessibleGroups = ->
        CurrentUser().groups()

      $scope.redirectToGroupPage = (groupId) ->
        if $scope.group.id == parseInt(groupId)
          $mdSidenav('left').close()
        else
          $location.path("/groups/#{groupId}")

      return