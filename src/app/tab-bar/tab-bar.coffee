angular.module('budget-tab-bar', [])
	.controller 'BudgetTabBarCtrl', ($rootScope, $scope, $stateParams) ->
    $rootScope.groupId = $stateParams.groupId
