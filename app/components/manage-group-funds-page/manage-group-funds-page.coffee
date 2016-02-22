module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds'
  template: require('./manage-group-funds-page.html')
  controller: (CurrentUser, Error, LoadBar, Records, $scope, $stateParams, UserCan) ->

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

    $scope.csvData = ->
      groupMemberships = _.filter Records.memberships.collection.data, (membership) ->
        membership.groupId == groupId
      _.map groupMemberships, (membership) ->
        [membership.member().email, membership.rawBalance]

    $scope.csvFileName = ->
      timestamp = moment().format('YYYY-MM-DD-HH-mm-ss')
      "#{$scope.group.name}-member-data-#{timestamp}"

    return
