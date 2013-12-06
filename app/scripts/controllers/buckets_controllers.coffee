angular.module('controllers.buckets', [])
.controller('BucketController', ['API_PREFIX', '$rootScope', '$http', '$scope', '$state', 'Bucket', 'flash', (API_PREFIX, $rootScope, $http, $scope, $state, Bucket, flash)->
  $scope.budget_id = $state.params.budget_id
  #for create view vs edit view
  if $state.params.bucket_id?
    setMinMax = (bucket)->
      if bucket.minimum_cents?
        bucket.minimum = parseFloat(bucket.minimum_cents) / 100
      if bucket.maximum_cents?
        bucket.maximum = parseFloat(bucket.maximum_cents) / 100
      bucket
    $http(
      method: 'GET',
      url: "#{API_PREFIX}/show_buckets"
      params:
        bucket_id: $state.params.bucket_id
    ).success((data, status, headers, config)->
      setMinMax(data)
      $scope.bucket = data
    )
    .error((data, status, headers, config)->
      console.log "Error", data
    )
  else
    $scope.bucket = {}

  $scope.update = (bucket)->
    bucket.user_id = 1
    console.log $state.params.bucket_id
    bucket.bucket_id = $state.params.bucket_id
    $http(
      method: 'POST'
      url: "#{API_PREFIX}/update_buckets"
      params: bucket
    ).success((data, status, headers, config)->
      $scope.bucket = data
      flash('success', 'Bucket updated.', 2000)
      $state.go('budgets.buckets', budget_id: data.budget_id)
    )
    .error((data, status, headers, config)->
      console.log "Error", data
    )

  $scope.create = (bucket)->
    bucket.budget_id = $state.params.budget_id
    bucket.user_id = "1"
    
    $http(
      method: 'POST'
      url: "#{API_PREFIX}/create_buckets"
      params: bucket
      ).success((data, status, headers, config)->
        bucket = {}
        $scope.bucket = {}
        flash('success', 'Bucket created.', 2000)
      )
      .error((data, status, headers, config)->
        console.log "Error", data
      )
]).controller('BucketItem', ['API_PREFIX', '$rootScope', '$http', '$scope', '$state', 'Bucket', 'flash', (API_PREFIX, $rootScope, $http, $scope, $state, Bucket, flash)->

  $scope.allocations = [
    {
      user_name: "Sterny McGrumpface"
      amount: 100
    },
    {
      user_name: "Dolly Malone"
      amount: 20
    },
    {
      user_name: "fanny may"
      amount: 20
    },
    {
      user_name: "way may"
      amount: 700
    }]

])
