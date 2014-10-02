`// @ngInject`
window.Cobudget.Controllers.BudgetAllocations = ($scope, $rootScope, RoundLoader) ->
  RoundLoader.init($rootScope)
  RoundLoader.loadFromURL()
