module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId'
  template: require('./group-page.html')
  params:
    openMembersTab: null
    firstTimeSeeingGroup: null
  controller: (CurrentUser, Error, LoadBar, $location, Records, $scope, $stateParams, UserCan) ->
    LoadBar.start()

    if $stateParams.openMembersTab
      $scope.tabSelected = 1

    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if UserCan.viewGroup(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
          $scope.currentUser = CurrentUser()
          $scope.membership = group.membershipFor(CurrentUser())
          Records.memberships.fetchByGroupId(groupId)
          Records.buckets.fetchByGroupId(groupId).then ->
            LoadBar.stop()
          Records.contributions.fetchByGroupId(groupId)
        else
          $scope.authorized = false
          LoadBar.stop()
          Error.set('cannot view group')
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    return
