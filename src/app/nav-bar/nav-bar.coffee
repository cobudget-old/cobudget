angular.module('nav-bar', [])
	.controller 'NavBarCtrl', ($rootScope, $scope, $state, AuthService, groups) ->

    $scope.groups = groups

    $rootScope.$watch 'groupId', (groupId) ->
      if groupId
        $scope.selectedGroup = _.find $scope.groups, (group) ->
          group.id.toString() == groupId.toString()

    $scope.$watch 'selectedGroup', (group) ->
      if group
        $state.go('nav.budget.overview', groupId: group.id)

    $scope.showLogin = () ->
      AuthService.loginModalCtrl.open()

    $scope.logout = () ->
      AuthService.logout()
