controller = ($scope, $rootScope, Budget) ->
  $scope.budgets = Budget.myBudgets()

  $scope.currentBudgetId = ''
  if $rootScope.currentBudget
    $scope.currentBudgetId = $rootScope.currentBudget.id

  $scope.setBudget = (id) ->
    budget = _.first(_.where($scope.budgets, {'id': id}))
    $rootScope.currentBudget = budget if budget

  $scope.$watch 'currentBudgetId', $scope.setBudget

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/nav-bar/nav-bar.html'
    controller: controller
  }
