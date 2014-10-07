`// @ngInject`
angular.module('cobudget').controller 'BudgetOverview', ($scope, $rootScope, BudgetLoader) ->
  BudgetLoader.init($rootScope)
  BudgetLoader.loadAll()
