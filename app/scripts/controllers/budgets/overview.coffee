`// @ngInject`
window.Cobudget.Controllers.BudgetOverview = ($scope, $rootScope, RoundLoader) ->
  RoundLoader.init($rootScope)
  RoundLoader.loadAll()
