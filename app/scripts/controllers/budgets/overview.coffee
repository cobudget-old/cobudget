window.Cobudget.Controllers.BudgetOverview = ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($scope, $rootScope)
  BudgetLoader.loadFromURL()
