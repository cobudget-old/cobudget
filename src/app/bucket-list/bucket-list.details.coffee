angular.module('bucket-list')
  .controller 'BucketListDetailsCtrl', ($scope, $stateParams, BucketService) ->
    #$scope.bucket = {id: "1", name:"Fund"}

    BucketService.get($stateParams.bucketId).then (bucket) ->
      $scope.bucket = bucket
