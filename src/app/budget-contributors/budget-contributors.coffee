angular.module('budget-contributors', [])
	.controller 'BudgetContributorsCtrl', ($scope, latestRound) ->
    $scope.contributors = latestRound.getContributors()
