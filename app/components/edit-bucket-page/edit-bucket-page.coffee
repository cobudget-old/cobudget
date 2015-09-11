module.exports = 
  url: '/projects/:projectId/edit'
  template: require('./edit-bucket-page.html')
  controller: ($scope, Records, $stateParams, $location, Toast) ->
    projectId = parseInt $stateParams.projectId

    Records.buckets.findOrFetchById(projectId).then (bucket) ->
      $scope.bucket = bucket
      # temp hack to get around target form number validation
      $scope.bucket.target = parseInt $scope.bucket.target
            
    $scope.cancel = () ->
      $location.path("/projects/#{projectId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save()
        Toast.show('Your edits have been saved')
        $scope.cancel()