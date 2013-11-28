angular.module('controllers.buckets', [])
.controller('BucketController', ['API_PREFIX', '$http', '$scope', '$state', 'Bucket', 'flash', (API_PREFIX, $http, $scope, $state, Bucket, flash)->
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
    bucket.bucket_id = 1
    $http(
      method: 'POST'
      url: "#{API_PREFIX}/update_buckets"
      params: bucket
    ).success((data, status, headers, config)->
      $scope.bucket = data
      flash('Bucket Updated')
      $state.go('budgets.buckets', id: data.budget_id)
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
        flash('Whoopee, Bucket created!')
      )
      .error((data, status, headers, config)->
        console.log "Error", data
      )
])
