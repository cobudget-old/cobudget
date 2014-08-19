controller = ($scope, $rootScope, Budget, BudgetLoader) ->
  BudgetLoader.init($scope, $rootScope)
  BudgetLoader.loadFromRootScope()

  $scope.$watch 'currentBudgetId', (id) ->
    #$location.path = "budgets/" + id #something like this?
    #keep budget loader setting rootscope so we don't need to load later
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
