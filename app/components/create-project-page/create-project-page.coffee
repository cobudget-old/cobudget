module.exports = 
  url: '/groups/:groupId/projects/new'
  template: require('./create-project-page.html')
  controller: ($scope, Records, $stateParams, $location, Toast) ->
    $scope.bucket = Records.buckets.build()
    $scope.bucket.groupId = parseInt($stateParams.groupId)
      
    $scope.cancel = () ->
      $location.path("/groups/#{$stateParams.groupId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        # temp hack - because, save doesn't set the right request headers
        $scope.bucket.create().then ->
          $scope.cancel()