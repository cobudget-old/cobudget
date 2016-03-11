module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/invite_members/review_upload'
  template: require('./review-bulk-invite-members-page.html')
  params:
    people: null
    groupId: null
  controller: (config, CurrentUser, Dialog, Error, LoadBar, $location, $q, Records, $scope, $state, $stateParams, $timeout, UserCan) ->

    $scope.uploadStatus = 'standby'

    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    unless $stateParams.people
      $location.path("/groups/#{groupId}/invite_members")

    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        LoadBar.stop()
        if UserCan.inviteMembersToGroup(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
          $scope.currentUser = CurrentUser()
          Records.memberships.fetchByGroupId(groupId)
          $scope.preparePeopleList()
        else
          $scope.authorized = false
          Error.set("you can't view this page")
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    $scope.preparePeopleList = ->
      $scope.people = _.map $stateParams.people, (person) ->
        person.deferred = $q.defer()
        person
      $scope.newMembers = []
      $scope.existingMembers = []
      _.each $scope.people, (person) ->
        if person.new_member
          $scope.newMembers.push(person)
        else
          $scope.existingMembers.push(person)

    $scope.openUploadCSVPrimerDialog = ->
      uploadCSVPrimerDialog = require('./../bulk-invite-members-primer-dialog/bulk-invite-members-primer-dialog.coffee')({
        scope: $scope
      })
      Dialog.open(uploadCSVPrimerDialog)

    $scope.cancel = ->
      $location.path("/groups/#{groupId}")

    $scope.confirmBulkInvites = ->
      $scope.uploadStatus = 'pending'
      promises = _.map $scope.people, (person) ->
        person.deferred.promise

      _.each $scope.newMembers, (newMember) ->
        newMember.status = 'pending'
        params = {group_id: groupId, email: newMember.email}
        Records.memberships.remote.create(params).then (data) ->
          newMembership = data.memberships[0]
          Records.memberships.invite(newMembership).then ->
            newMember.status = 'complete'
            newMember.deferred.resolve()

      _.each $scope.existingMembers, (existingMember) ->
        existingMember.status = 'complete'
        existingMember.deferred.resolve()

      $q.allSettled(promises).then ->
        $scope.uploadStatus = 'complete'

    $scope.done = ->
      $scope.cancel()

    $scope.seeAllMembers = ->
      $state.go('group', {groupId: groupId, openMembersTab: true})

    return
