controller = ($scope, $rootScope, Budget) ->
  $scope.currentBudgetId = ''
  if $rootScope.currentBudget
    $scope.currentBudgetId = $rootScope.currentBudget.id

  Budget.allBudgets().then (budgets) ->
    $scope.budgets = budgets

    $scope.setBudget = (id) ->
      budget = _.first(_.where($scope.budgets, {'id': id}))
      $rootScope.currentBudget = budget if budget

    $scope.$watch 'currentBudgetId', (id) ->
      $scope.setBudget(id)

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/nav-bar/nav-bar.html'
    controller: controller
  }
