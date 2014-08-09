NavBarController = ($scope, $rootScope, Budget) ->
  $scope.budgets = Budget.myBudgets()

  $scope.currentBudgetId = ''
  if $rootScope.currentBudget
    $scope.currentBudgetId = $rootScope.currentBudget.id

  $scope.$watch 'currentBudgetId', (id) ->
    budget = _.first $scope.budgets, {id: id}

window.Cobudget.Directives.NavBar = ->
  {
    restrict: 'EA'
    templateUrl: '/scripts/directives/nav-bar/nav-bar.html'
    controller: NavBarController
  }
