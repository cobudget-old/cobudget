window.Cobudget.Controllers.BudgetContributors = ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($rootScope)
  BudgetLoader.loadFromURL()
