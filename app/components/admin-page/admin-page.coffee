module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/settings'
  template: require('./admin-page.html')
  controller: (CurrentUser, Error, $location, Records, $scope, UserCan, Toast, $stateParams) ->

    groupId = parseInt($stateParams.groupId)

    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if CurrentUser().isAdminOf(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
        else
          $scope.authorized = false
          Error.set("you can't view this page")
      .catch ->
        Error.set('group not found')

    $scope.currencies = [
      { code: 'USD', symbol: '$' },
      { code: 'NZD', symbol: '$' },
      { code: 'GBP', symbol: '£' },
      { code: 'EUR', symbol: '€' },
      { code: 'CHF', symbol: 'CHF' },
      { code: 'JPY', symbol: '¥' }
    ]

    $scope.updateGroup = () ->
      Records.groups.findOrFetchById(groupId).then (group) ->
        group.save()
        Toast.show('You updated '+group.name)

    $scope.viewGroup = (groupId) ->
      $location.path("/groups/#{groupId}")

    $scope.cancel = () ->
      $location.path("/groups/#{groupId}")

    return
