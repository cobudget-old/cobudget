module.exports = 
  url: '/groups/:groupId/projects/:projectId'
  template: require('./project-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    
    groupId = parseInt $stateParams.groupId

    $scope.back = ->
      $location.path("/groups/#{groupId}")