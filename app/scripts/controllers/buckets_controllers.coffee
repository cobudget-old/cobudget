angular.module('controllers.buckets', [])
.controller('BucketController', ['$rootScope', '$scope', '$state', 'Bucket', 'flash', 'User', ($rootScope, $scope, $state, Bucket, flash, User)->
  $scope.budget_id = $state.params.budget_id

  $scope._bucket = {}
  $scope.bucket = {}

  if $state.params.bucket_id?
    Bucket.getBucket($state.params.bucket_id).then (success)->
      $scope.bucket = Bucket.setMinMax(success)
    , (error)->
      console.log error

  $scope.update = ()->
    $scope.bucket.user_id = 1
    $scope.bucket.bucket_id = $state.params.bucket_id
    $scope.bucket.put().then (success)->
      $scope.bucket = success
      flash('success', 'Bucket Updated.', 2000)
      $state.go('budgets.buckets', {budget_id: success.budget_id})
    , (error)->
      console.log error

  $scope.create = ()->
    $scope._bucket.budget_id = $state.params.budget_id
    $scope._bucket.user_id = User.getCurrentUser().id
    $scope._bucket.sponsor_id = User.getCurrentUser().id
    Bucket.createBucket($scope._bucket).then (success)->
      $scope._bucket = {}
      flash('success', 'Bucket created.', 2000)
      $state.go('budgets.buckets', {budget_id: success.budget_id})
    , (error)->
      console.log error


]).controller('BucketItem', ['$rootScope', '$http', '$scope', '$state', 'Bucket', 'flash', 'Allocation', ($rootScope, $http, $scope, $state, Bucket, flash, Allocation)->
  $scope.$watch 'b.allocations', (n, o)->
    $scope.$parent.$parent.$parent.prepareUserAllocations() 
  , true

  $scope.delete = ()->
    buckets = $scope.$parent.$parent.$parent.buckets
    $scope.b.remove({user_id: "1"}).then (success)->
      flash('success', 'Bucket deleted.', 200000)
      for b, i in buckets
        if b.id == buckets[i].id
          buckets.splice(i, 1)
          return
    , (error)->
      console.log error
])
