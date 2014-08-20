window.Cobudget.Controllers.BudgetContributors = ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($scope, $rootScope)
  BudgetLoader.loadFromURL()
