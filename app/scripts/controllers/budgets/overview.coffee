window.Cobudget.Controllers.BudgetOverview = ($scope) ->
  #if $rootScope.currentBudget doesn't exist load it from route params
  #otherwise set $scope.budget $rootScope.currentBudget
  $scope.message = 'hi'
