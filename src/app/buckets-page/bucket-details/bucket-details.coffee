angular.module('bucket-details', []).controller 'BucketDetailsCtrl', ($scope, $route, Bucket) ->
  console.log("routeparams", $route.current)
  #if $route.current.params.bucketId
    #$scope.bucket = Bucket.get($route.current.params.bucketId).$object
    #$scope.allocations = Bucket.getBucketAllocations($route.current.params.bucket_id).$object
    #console.log($scope.bucket)


///
 	Bucket.getBucketAllocations($route.current.params.bucket_id).then (allocations) ->
    new_list = []
    _.each allocations, (allocation) ->
      #console.log(allocation.amount)
      if allocation.amount > 0
        new_list.push allocation
      
    $scope.allocations = new_list
///
    	
