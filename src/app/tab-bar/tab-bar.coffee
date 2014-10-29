angular.module('budget-tab-bar', [])
	.controller 'BudgetTabBarCtrl', ($scope, $stateParams) ->
    $scope.groupId = $stateParams.groupId
