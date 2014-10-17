angular.module('budget-overview', [])
	.controller 'BudgetOverviewCtrl', ($scope, $rootScope, BudgetLoader) ->
	  BudgetLoader.init($rootScope)
	  BudgetLoader.setCurrent()
