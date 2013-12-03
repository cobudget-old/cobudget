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
      amount: 2000
    },
    {
      user_name: "Dolly Malone"
      amount: 1000
    }]

  #get from user
  $scope.$watch 'b.user_allocation', (n, o)->
    if n != o
      buckets = $scope.$parent.$parent.buckets

      allocatable = $scope.$parent.$parent.allocatable

      sum_of_other_buckets = 0
      sum_of_buckets = 0
      for bk in buckets
        unless bk.id == $scope.b.id
          sum_of_other_buckets += bk.user_allocation

      for bk in buckets
        sum_of_buckets += bk.user_allocation

      if n > (allocatable - sum_of_other_buckets)
        $scope.b.user_allocation = allocatable - sum_of_other_buckets
      else if sum_of_other_buckets > allocatable
        $scope.b.user_allocation = 0
      #potential directive
      else
        console.log n
        new_allocation = {user_name: "Tony Soprano", amount: n}
        allocated = false
        for i in [0...$scope.allocations.length]
          if new_allocation.user_name == $scope.allocations[i].user_name
            allocated = true
            $scope.allocations[i] = new_allocation
        if allocated == false
          $scope.allocations.push new_allocation

])
