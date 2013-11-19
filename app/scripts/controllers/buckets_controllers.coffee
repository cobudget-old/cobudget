angular.module('controllers.buckets', [])
.controller('BucketController', ['API_PREFIX', '$http', '$scope', '$state', 'Bucket', (API_PREFIX, $http, $scope, $state, Bucket)->
  $scope.bucket = {}
  $scope.update = (bucket)->
    $http(method: 'POST', url: "#{API_PREFIX}/update_buckets?bucket_id=#{$state.params.id}&name=test&description=testtst&minimum=1&maximum=2").
      success((data, status, headers, config)->
        console.log data
      )
      .error((data, status, headers, config)->
        console.log "Error", data
      )

  $scope.create = (bucket)->
    bucket.budget_id = $state.params.id
    delete bucket.name
    delete bucket.description 
    delete bucket.minimum
    delete bucket.maximum 
    bucket.user_id = "1"
    bucket.name = "ned:"
    bucket.description = "wals"
    
    $http(
      method: 'POST'
      url: "#{API_PREFIX}/create_buckets"
      data: $scope.bucket
      ).success((data, status, headers, config)->
        console.log data
      )
      .error((data, status, headers, config)->
        console.log "Error", data
      )
])
