module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds'
  template: require('./manage-group-funds-page.html')
  controller: (CurrentUser, DownloadCSV, Error, LoadBar, Records, $scope, $stateParams, UserCan) ->

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

    $scope.downloadCSV = ->
      params =
        url: "http://localhost:3000/api/v1/memberships.csv?group_id=#{groupId}"
        filename: 'fuck'
      DownloadCSV(params)
    return
