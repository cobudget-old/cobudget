module.exports = 
  url: '/groups/:groupId/projects/:projectId'
  template: require('./project-page.html')
  controller: ($scope, Records, $stateParams, $location) ->

    groupId = parseInt $stateParams.groupId
    projectId = parseInt $stateParams.projectId
    
    Records.groups.findOrFetchByKey(groupId).then (group) ->
      $scope.group = group

    Records.buckets.findOrFetchByKey(projectId).then (bucket) ->
      $scope.bucket = bucket

    $scope.back = ->
      $location.path("/groups/#{groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false