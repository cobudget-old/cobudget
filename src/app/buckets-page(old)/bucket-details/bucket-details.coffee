angular.module('bucket-details', [])
  .controller 'BucketDetailsCtrl', ($scope, $stateParams, Bucket) ->
    $scope.bucket = {
      name: "fake scope bucket"
      sponsor_name_or_email: "Derek Razo"
      description: "This is a dope budget for real"
      amount_filled: 10000000
      maximum_cents: 10000001
    } 

    console.log($stateParams)
  


///
 	Bucket.getBucketAllocations($route.current.params.bucket_id).then (allocations) ->
    new_list = []
    _.each allocations, (allocation) ->
      #console.log(allocation.amount)
      if allocation.amount > 0
        new_list.push allocation
      
    $scope.allocations = new_list

  #if $route.current.params.bucketId
    #$scope.bucket = Bucket.get($route.current.params.bucketId).$object
    #$scope.allocations = Bucket.getBucketAllocations($route.current.params.bucket_id).$object
    #console.log($scope.bucket)
///
    	
