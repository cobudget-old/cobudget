module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds/review_upload'
  template: require('./review-bulk-allocation-page.html')
  params:
    people: null
    groupId: null
  controller: (config, CurrentUser, Dialog, Error, LoadBar, $location, $q, Records, $scope, $state, $stateParams, $timeout, UserCan) ->

    $scope.uploadStatus = 'standby'

    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    unless $stateParams.people
      $location.path("/groups/#{groupId}/manage_funds")

    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        LoadBar.stop()
        if UserCan.manageFundsForGroup(group)
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

    $scope.abs = (val) ->
      Math.abs(val)

    $scope.preparePeopleList = ->
      $scope.people = _.map $stateParams.people, (person) ->
        person.deferred = $q.defer()
        person.allocation_amount = parseFloat(person.allocation_amount)
        person
      $scope.peopleWithPositiveAllocations = []
      $scope.newMembers = []
      $scope.existingMembers = []
      _.each $scope.people, (person) ->
        if person.allocation_amount > 0
          $scope.peopleWithPositiveAllocations.push(person)
        if person.new_member
          $scope.newMembers.push(person)
        else
          $scope.existingMembers.push(person)

    $scope.summedAllocationsFrom = (people) ->
      callback = (sum, person) ->
        sum + Math.abs(parseFloat(person.allocation_amount))
      _.reduce(people, callback, 0)

    $scope.openUploadCSVPrimerDialog = ->
      uploadCSVPrimerDialog = require('./../bulk-allocation-primer-dialog/bulk-allocation-primer-dialog.coffee')({
        scope: $scope
      })
      Dialog.open(uploadCSVPrimerDialog)

    $scope.cancel = ->
      $location.path("/groups/#{groupId}")

    # TODO: eww - definitely refactor
    $scope.confirmBulkAllocations = ->
      $scope.uploadStatus = 'pending'
      promises = _.map $scope.people, (person) ->
        person.deferred.promise

      _.each $scope.newMembers, (newMember) ->
        newMember.status = 'pending'
        membershipParams = {group_id: groupId, email: newMember.email}
        Records.memberships.remote.create(membershipParams).then (data) ->
          newMembership = data.memberships[0]
          if newMember.allocation_amount > 0
            allocationParams = {groupId: groupId, userId: data.users[0].id, amount: newMember.allocation_amount}
            allocation = Records.allocations.build(allocationParams)
            allocation.save().then ->
              Records.memberships.invite(newMembership).then ->
                newMember.status = 'complete'
                newMember.deferred.resolve()
          else
            Records.memberships.invite(newMembership).then ->
              newMember.status = 'complete'
              newMember.deferred.resolve()

      _.each $scope.existingMembers, (existingMember) ->
        existingMember.status = 'pending'
        if existingMember.allocation_amount > 0
          params = {groupId: groupId, userId: existingMember.id, amount: existingMember.allocation_amount}
          allocation = Records.allocations.build(params)
          allocation.save().then ->
            existingMember.status = 'complete'
            existingMember.deferred.resolve()
        else
          existingMember.status = 'complete'
          existingMember.deferred.resolve()

      $q.allSettled(promises).then ->
        $scope.uploadStatus = 'complete'

    $scope.done = ->
      $scope.cancel()

    $scope.seeAllMembers = ->
      $state.go('group', {groupId: groupId, openMembersTab: true})

    return
