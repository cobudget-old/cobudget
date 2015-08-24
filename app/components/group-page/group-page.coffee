module.exports = 
  resolve: 
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, Toast) ->

    groupId = parseInt($stateParams.groupId) 
    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.currentMembership = group.membershipFor(CurrentUser())
      Records.buckets.fetchByGroupId(group.id)
      Records.memberships.fetchByGroupId(group.id)

    window.scrollHeight = 0;

    $scope.createProject = ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")

    $scope.showProject = (projectId) ->
      $location.path("/groups/#{$stateParams.groupId}/projects/#{projectId}")

    $scope.selectTab = (tabNum) ->
      $scope.tabSelected = parseInt tabNum

    return