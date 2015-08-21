module.exports = 
  url: '/groups/:groupId/projects/:projectId/edit'
  template: require('./edit-project-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    $scope.groupId = parseInt $stateParams.groupId
    $scope.projectId = parseInt $stateParams.projectId

    Records.buckets.findOrFetchById($scope.projectId).then (bucket) ->
      $scope.bucket = bucket
      # temp hack to get around target form number validation
      $scope.bucket.target = parseInt $scope.bucket.target
            
    $scope.cancel = () ->
      $location.path("/groups/#{$scope.groupId}/projects/#{$scope.projectId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save()
        $scope.cancel()