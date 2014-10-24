controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $state, $routeParams, GroupService, BudgetLoader, AuthService) ->
  BudgetLoader.init($rootScope)

  # TODO much of this should be in a routing service
  # pulling in any route functionality from BudgetLoader

  $scope.$watch 'currentBudgetId', (currentBudgetId) ->
    if currentBudgetId > 0
      $state.go('bucketList', {groupId: currentBudgetId})

  BudgetLoader.loadAll()

  $scope.showLogin = () ->
    AuthService.loginModalCtrl.open()

  $scope.logout = () ->
    AuthService.logout()

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/app/nav-bar/nav-bar.html'
    controller: controller
  }
