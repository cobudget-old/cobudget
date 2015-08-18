module.exports = 
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location) ->
    groupId = parseInt($stateParams.groupId) 
    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      Records.buckets.fetchByGroupId(group.id)
      Records.memberships.fetchByGroupId(group.id)

    window.scrollHeight = 0;

    $scope.createProject = ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")

    $scope.showProject = (projectId) ->
      $location.path("/groups/#{$stateParams.groupId}/projects/#{projectId}")

    $scope.showDraft = (draftId) ->
      $location.path("/groups/#{$stateParams.groupId}/drafts/#{draftId}")

    $scope.selectTab = (tabNum) ->
      $scope.tabSelected = parseInt tabNum

    return