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

    $scope.openCreateGroupDialog = ->      
      Dialog.custom
        scope: $scope
        template: require('./create-group-dialog-content.tmpl.html')

    $scope.createGroup = ->
      $scope.newGroup.save()
        .then (data) ->
          Dialog.alert
            title: 'Success!'
            content: 'Group created.'
          newGroupId = data.groups[0].id
          Records.memberships.fetchMyMemberships().then (data) ->
            $scope.accessibleGroups = CurrentUser().groups()
          $scope.newGroup = Records.groups.build()

    $scope.openInviteGroupDialog = ->
      Dialog.custom
        scope: $scope
        template: require('./invite-group-dialog-content.tmpl.html')

    $scope.inviteGroup = () ->
      Records.users.inviteToCreateGroup($scope.formData)
        .then ->
          Dialog.alert
            title: 'Success!'
            content: "Your invite was sent."
          $scope.formData = {}
        .catch ->
          Dialog.alert
            title: 'Error!'
            content: 'Email invalid or already taken.'

    $scope.closeDialog = ->
      Dialog.close()

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