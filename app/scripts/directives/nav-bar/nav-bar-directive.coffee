controller = ($scope, $rootScope, Budget, BudgetLoader) ->
  BudgetLoader.init($scope, $rootScope)
  BudgetLoader.loadFromRootScope()

  $scope.$watch 'currentBudgetId', (id) ->
    BudgetLoader.setBudget(id)

  Budget.allBudgets().then (budgets) ->
    $scope.budgets = budgets
    BudgetLoader.defaultToFirstBudget()

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/nav-bar/nav-bar.html'
    controller: controller
  }
