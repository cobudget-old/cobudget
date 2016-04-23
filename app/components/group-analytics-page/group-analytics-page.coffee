module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/analytics'
  template: require('./group-analytics-page.html')
  controller: (config, CurrentUser, Error, $http, Records, $scope, $state, $stateParams, UserCan) ->

    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if UserCan.viewGroup(group)
          $scope.authorized = true
          Error.clear()
          $http.get(config.apiPrefix + "/groups/#{groupId}/analytics")
            .then (res) ->
              $scope.data = res.data
              $scope.dataLoaded = true
        else
          $scope.authorized = false
          Error.set("you can't view this page")

    $scope.back = ->
      $state.go('group', {groupId: groupId})

    return
