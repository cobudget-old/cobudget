module.exports = 
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/admin'
  template: require('./admin-page.html')
  controller: (config, CurrentUser, Dialog, Error, $location, Records, $scope, UserCan) ->

    $scope.currencies = [
      { code: 'USD', symbol: '$' },
      { code: 'NZD', symbol: '$' },
      { code: 'EUR', symbol: '€' }
    ]

    if UserCan.viewAdminPanel()
      $scope.authorized = true
      Error.clear()
      $scope.accessibleGroups = CurrentUser().groups()
    else
      $scope.authorized = false
      Error.set("you can't view this page")

    $scope.newGroup = Records.groups.build()

    $scope.createGroup = ->
      $scope.newGroup.save().then (data) ->
        newGroupId = data.groups[0].id
        Records.memberships.fetchMyMemberships().then (data) ->
          $scope.accessibleGroups = CurrentUser().groups()
        $scope.newGroup = Records.groups.build()

    $scope.uploadPathForGroup = (groupId) ->
      "#{config.apiPrefix}/allocations/upload?group_id=#{groupId}"

    $scope.onCsvUploadSuccess = (groupId) ->
      Records.groups.findOrFetchById(groupId)

    $scope.onCsvUploadCompletion = ->
      Dialog.alert(title: 'upload complete!')

    $scope.updateGroupCurrency = (groupId, currencyCode) ->
      Records.groups.findOrFetchById(groupId).then (group) ->
        group.currencyCode = currencyCode
        group.save()

    $scope.viewGroup = (groupId) ->
      $location.path("/groups/#{groupId}")

    return