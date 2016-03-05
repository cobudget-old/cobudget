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
  controller: (config, CurrentUser, Error, LoadBar, Dialog, Records, $scope, $stateParams, $timeout, UserCan) ->

    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        LoadBar.stop()
        if UserCan.manageFundsForGroup(group)
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

    $scope.people = ->
      $stateParams.people

    $scope.people = [
      {email: 'derek@enspiral.com', name: 'Derek Razo', allocation_amount: '+$350' , new_member: false},
      {email: 'eugene@enspiral.com', name: 'Eugene Lynch', allocation_amount: '+$350' , new_member: false},
      {email: 'chelsearobinson@gmail.com', name: '', allocation_amount: '+$0' , new_member: true},
    ]

    console.log('$stateParams: ', $stateParams)

    return
