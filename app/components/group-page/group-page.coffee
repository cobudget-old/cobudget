module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: (CurrentUser, Error, LoadBar, Records, $scope, $stateParams, UserCan) ->

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
