angular.module('budget-overview', [])
	.controller 'BudgetOverviewCtrl', ($scope, $stateParams) ->
    $scope.groupId = $stateParams.groupId