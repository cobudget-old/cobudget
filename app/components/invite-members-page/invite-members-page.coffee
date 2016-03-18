module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/invite_members'
  template: require('./invite-members-page.html')
  controller: (config, CurrentUser, Dialog, DownloadCSV, Error, $location, LoadBar, Records, $scope, $state, $stateParams, Toast, UserCan) ->

    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        LoadBar.stop()
        if UserCan.inviteMembersToGroup(group)
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

    $scope.openInviteMembersPrimerDialog = ->
      inviteMembersPrimerDialog = require('./../bulk-invite-members-primer-dialog/bulk-invite-members-primer-dialog.coffee')({
        scope: $scope
      })
      Dialog.open(inviteMembersPrimerDialog)

    $scope.redirectToManageGroupFundsPage = ->
      Dialog.close()
      $location.path("/groups/#{groupId}/manage_funds")

    $scope.cancel = ->
      $location.path("/groups/#{groupId}")

    $scope.inviteMemberFormParams = {group_id: groupId}

    $scope.inviteMember = ->
      Records.memberships.remote.create($scope.inviteMemberFormParams)
        .then (data) ->
          newMembership = data.memberships[0]
          Records.memberships.invite(newMembership).then ->
            $state.reload()
            Toast.show('Invitation sent!')
        .catch ->
          Dialog.alert({title: 'error!', content: 'member already exists'})

    return
