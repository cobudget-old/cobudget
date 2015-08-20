module.exports = 
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, ipCookie) ->

    groupId = parseInt($stateParams.groupId) 
    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.currentMembership = group.membershipFor(CurrentUser.get())
      console.log('(group-page) currentMembership: ', $scope.currentMembership)
      Records.buckets.fetchByGroupId(group.id)
      Records.memberships.fetchByGroupId(group.id)

    window.scrollHeight = 0;

    if ipCookie('newProjectOpenForFunding')
      alert('meow meow')

    $scope.createProject = ->
      $location.path("/groups/#{$stateParams.groupId}/projects/new")

    $scope.showProject = (projectId) ->
      $location.path("/groups/#{$stateParams.groupId}/projects/#{projectId}")

    $scope.selectTab = (tabNum) ->
      $scope.tabSelected = parseInt tabNum

    return