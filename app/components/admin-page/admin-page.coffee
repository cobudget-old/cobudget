module.exports = 
  resolve:
    userValidated: ->
      global.cobudgetApp.userValidated
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/admin'
  template: require('./admin-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope, config, CurrentUser, UserCan, $state) ->

    $scope.currencies = [
      { code: 'USD', symbol: '$' },
      { code: 'NZD', symbol: '$' },
      { code: 'EUR', symbol: '€' }
    ]

    if UserCan.viewAdminPanel()
      $scope.accessibleGroups = CurrentUser().groups()

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
      alert('upload complete')

    $scope.updateGroupCurrency = (groupId, currencyCode) ->
      Records.groups.findOrFetchById(groupId).then (group) ->
        group.currencyCode = currencyCode
        group.save()

    $scope.viewGroup = (groupId) ->
      $location.path("/groups/#{groupId}")

    return