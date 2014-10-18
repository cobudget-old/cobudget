controller = null
`// @ngInject`
controller = ($location, $scope, $rootScope, $routeParams, Organization, BudgetLoader) ->
  BudgetLoader.init($rootScope)

  # TODO much of this should be in a routing service
  # pulling in any route functionality from BudgetLoader

  $scope.$watch 'currentBudgetId', (currentBudgetId) ->
    if currentBudgetId > 0
      $location.path '/organizations/' + currentBudgetId
      BudgetLoader.setBudgetByRoute()

  $scope.budgets = $rootScope.budgets

  BudgetLoader.loadAll()
    #console.log(budgets)

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/app/nav-bar/nav-bar.html'
    controller: controller
  }
