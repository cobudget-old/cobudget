module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/admin'
  template: require('./admin-page.html')
  controller: (CurrentUser, Error, $location, Records, $scope, UserCan) ->

    $scope.currencies = [
      { code: 'USD', symbol: '$' },
      { code: 'NZD', symbol: '$' },
      { code: 'EUR', symbol: '€' }
    ]

    if UserCan.viewAdminPanel()
      $scope.authorized = true
      Error.clear()
      $scope.accessibleGroups = CurrentUser().administeredGroups()
    else
      $scope.authorized = false
      Error.set("you can't view this page")

    $scope.updateGroupCurrency = (groupId, currencyCode) ->
      Records.groups.findOrFetchById(groupId).then (group) ->
        group.currencyCode = currencyCode
        group.save()

    $scope.viewGroup = (groupId) ->
      $location.path("/groups/#{groupId}")

    return
