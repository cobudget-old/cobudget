module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId?tab'
  template: require('./group-page.html')
  params:
    firstTimeSeeingGroup: null
  controller: (CurrentUser, Error, LoadBar, $location, Records, $scope, $stateParams, UserCan, $window) ->
    LoadBar.start()

    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if UserCan.viewGroup(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
          $scope.currentUser = CurrentUser()
          $scope.membership = group.membershipFor(CurrentUser())
          Records.buckets.fetchByGroupId(groupId).then ->
            LoadBar.stop()
          Records.contributions.fetchByGroupId(groupId)
        else if CurrentUser().isSuperAdmin
          $window.location.reload()
        else
          $scope.authorized = false
          LoadBar.stop()
          Error.set('cannot view group')
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    return
