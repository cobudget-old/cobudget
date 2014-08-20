window.Cobudget.Controllers.BudgetAllocations = ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($scope, $rootScope)
  BudgetLoader.loadFromURL()
