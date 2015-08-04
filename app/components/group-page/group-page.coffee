module.exports = 
  url: '/groups/:groupId'
  template: require('app/components/group-page/group-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    groupId = parseInt($stateParams.groupId) 
    Records.groups.findOrFetchByKey(groupId).then (group) ->
      $scope.group = group
      Records.buckets.fetchByGroupId(group.id)
      
    window.scrollHeight = 0;

    $scope.createProject = () ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")