module.exports = 
  url: '/groups/:groupId/projects/:projectId'
  template: require('./project-page.html')
  controller: ($scope, Records, $stateParams, $location) ->

    groupId = parseInt $stateParams.groupId
    projectId = parseInt $stateParams.projectId
    
    Records.buckets.findOrFetchByKey(projectId).then (bucket) ->
      $scope.bucket = bucket

    $scope.back = ->
      $location.path("/groups/#{groupId}")

