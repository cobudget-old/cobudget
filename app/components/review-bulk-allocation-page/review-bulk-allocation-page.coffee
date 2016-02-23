module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds/review_upload'
  template: require('./review-bulk-allocation-page.html')
  controller: (config, CurrentUser, Error, LoadBar, Dialog, Records, $scope, $stateParams, $timeout, UserCan) ->

    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        LoadBar.stop()
        if UserCan.manageFundsForGroup(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
          $scope.currentUser = CurrentUser()
          Records.memberships.fetchByGroupId(groupId)
        else
          $scope.authorized = false
          Error.set("you can't view this page")
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    return
