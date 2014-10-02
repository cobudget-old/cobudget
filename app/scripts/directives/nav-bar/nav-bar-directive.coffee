controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $routeParams, Budget, RoundLoader) ->
  RoundLoader.init($rootScope)

  # TODO much of this should be in a routing service
  # pulling in any route functionality from RoundLoader

  $scope.$watch 'currentBudgetId', (currentBudgetId) ->
    if currentBudgetId > 0
      $location.path '/budgets/' + currentBudgetId
      RoundLoader.setBudgetByRoute()

  $scope.budgets = $rootScope.budgets

  RoundLoader.loadAll()
    #console.log(budgets)

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/nav-bar/nav-bar.html'
    controller: controller
  }
