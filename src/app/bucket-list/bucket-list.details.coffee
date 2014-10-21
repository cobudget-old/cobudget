angular.module('bucket-list')
  .controller 'BucketListDetailsCtrl', ($scope, $stateParams, Bucket) ->
    #$scope.bucket = {id: "1", name:"Fund"}

    Bucket.get($stateParams.bucketId).then (bucket) ->
      $scope.bucket = bucket
