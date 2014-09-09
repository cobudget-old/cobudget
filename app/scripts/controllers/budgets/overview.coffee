`// @ngInject`
window.Cobudget.Controllers.BudgetOverview = ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($rootScope)
  BudgetLoader.loadFromURL()
