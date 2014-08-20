`// @ngInject`
window.Cobudget.Controllers.BudgetAllocations = ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($rootScope)
  BudgetLoader.loadFromURL()
