angular.module('bucket-list', [])
	.controller 'BucketListCtrl', ($scope, $stateParams) ->
		$scope.buckets = 
		[
			{id: "1", name: "fake1", description: "Something with profanity"}
			{id: "2", name: "fake2", description: "Something serious"}
		]
		$scope.budgetId = $stateParams.budgetId
