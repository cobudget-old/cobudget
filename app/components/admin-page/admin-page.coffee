module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/admin'
  template: require('./admin-page.html')
  controller: (CurrentUser, Error, $location, Records, $scope, UserCan, Toast) ->

    $scope.currencies = [
      { code: 'USD', symbol: '$' },
      { code: 'NZD', symbol: '$' },
      { code: 'GBP', symbol: '£' },
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
        Toast.show('You updated '+group.name)

    $scope.viewGroup = (groupId) ->
      $location.path("/groups/#{groupId}")

    $scope.cancel = () ->
      groupId = CurrentUser().primaryGroup().id
      $location.path("/groups/#{groupId}")

    return
