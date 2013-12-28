angular.module('controllers.buckets', [])
.controller('BucketController', ['$rootScope', '$scope', '$state', 'Bucket', 'flash', ($rootScope, $scope, $state, Bucket, flash)->
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
      console.log success
    , (error)->
      console.log error

  $scope.create = ()->
    $scope._bucket.budget_id = $state.params.budget_id
    $scope._bucket.user_id = "1"
    Bucket.createBucket($scope._bucket).then (success)->
      $scope._bucket = {}
      flash('success', 'Bucket created.', 2000)
    , (error)->
      console.log error


]).controller('BucketItem', ['API_PREFIX', '$rootScope', '$http', '$scope', '$state', 'Bucket', 'flash', (API_PREFIX, $rootScope, $http, $scope, $state, Bucket, flash)->
  $scope.$watch 'b.allocations', (n, o)->
    if n != o
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
    #$http(
      #method: 'GET'
      #url: "#{API_PREFIX}/delete_buckets"
      #params: bk
      #).success((data, status, headers, config)->
        #$scope.b = {}
        #buckets = $scope.$parent.$parent.$parent.buckets
        #for b, i in buckets
          #if b.id == buckets[i].id
            #buckets.splice(i, 1)
            #return
        #flash('success', 'Bucket created.', 2000)
      #)
      #.error((data, status, headers, config)->
        #console.log "Error", data
      #)
])
