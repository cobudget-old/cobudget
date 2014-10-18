angular.module('bucket-list')
	.controller 'BucketListDetailsCtrl', ($scope, $stateParams) ->
		$scope.bucket =
			{name: "fake1", description: "Something with profanity"}

		console.log($stateParams)