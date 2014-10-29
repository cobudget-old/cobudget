angular.module('nav-bar', [])
	.controller 'NavBarCtrl', ($scope, $state, AuthService, groups) ->

    $scope.groups = groups

    $scope.$watch 'currentGroupId', (currentGroupId) ->
      if currentGroupId > 0
        $state.go('nav.budget', groupId: currentGroupId)

    $scope.showLogin = () ->
      AuthService.loginModalCtrl.open()

    $scope.logout = () ->
      AuthService.logout()
