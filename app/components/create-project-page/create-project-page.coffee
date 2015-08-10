module.exports = 
  url: '/groups/:groupId/projects/new'
  template: require('./create-project-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    $scope.bucket = Records.buckets.build()
    $scope.bucket.groupId = parseInt($stateParams.groupId)
      
    $scope.cancel = () ->
      $location.path("/groups/#{$stateParams.groupId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save().then ->
          $scope.cancel()