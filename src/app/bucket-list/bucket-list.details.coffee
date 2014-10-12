///
angular.module('bucket-list', [])
	.controller 'BucketDetailsCtrl', ($scope, $stateParams) ->
		$scope.bucket = 
			{name: "fake1", description: "Something with profanity"}

		console.log($stateParams)
///