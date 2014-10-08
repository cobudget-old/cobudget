`// @ngInject`
window.Cobudget.Controllers.BucketShow = ($scope, $route, Bucket) ->
  console.log("routeparams", $route.current.params)
  if $route.current.params.bucket_id
    $scope.bucket = Bucket.get($route.current.params.bucket_id).$object
    #$scope.allocations = Bucket.getBucketAllocations($route.current.params.bucket_id).$object
 

 	Bucket.getBucketAllocations($route.current.params.bucket_id).then (allocations) ->
    new_list = []
    _.each allocations, (allocation) ->
      #console.log(allocation.amount)
      if allocation.amount > 0
        new_list.push allocation
      
    $scope.allocations = new_list

    	
