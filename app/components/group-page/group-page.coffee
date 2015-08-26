module.exports = 
  resolve: 
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, Toast) ->

    groupId = parseInt($stateParams.groupId)
    global.cobudgetApp.currentGroupId = groupId
    
    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.currentMembership = group.membershipFor(CurrentUser())
      Records.buckets.fetchByGroupId(group.id).then (data) ->
        _.each data.buckets, (bucket) ->
          Records.comments.fetchByBucketId(bucket.id)
      Records.memberships.fetchByGroupId(group.id)

    window.scrollHeight = 0;

    $scope.createProject = ->
      $location.path("/projects/new")

    $scope.showProject = (projectId) ->
      $location.path("/projects/#{projectId}")

    $scope.selectTab = (tabNum) ->
      $scope.tabSelected = parseInt tabNum

    return