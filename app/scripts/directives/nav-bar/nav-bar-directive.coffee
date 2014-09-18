controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $routeParams, Budget, BudgetLoader) ->
  BudgetLoader.init($rootScope)

  # TODO much of this should be in a routing service
  # pulling in any route functionality from BudgetLoader

  $scope.$watch 'currentBudgetId', (currentBudgetId) ->
    if currentBudgetId > 0
      $location.path '/budgets/' + currentBudgetId
      BudgetLoader.setBudgetByRoute()

  $rootScope.$watch 'budgets', (budgets) ->
    $scope.budgets = budgets
    #console.log(budgets)

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/nav-bar/nav-bar.html'
    controller: controller
  }
