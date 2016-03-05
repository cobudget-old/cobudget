module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/manage_funds/review_upload'
  template: require('./review-bulk-allocation-page.html')
  params:
    people: [
      {email: 'derek@enspiral.com', name: 'Derek Razo', allocation_amount: '300' , new_member: false},
      {email: 'eugene@enspiral.com', name: 'Eugene Lynch', allocation_amount: '-100' , new_member: false},
      {email: 'data@doge.com', name: 'Data Doge', allocation_amount: '50' , new_member: false},
      {email: 'chelsearobinson@gmail.com', name: '', allocation_amount: '0' , new_member: true}
    ]
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
        person.allocation_amount = parseFloat(person.allocation_amount)
        person
      $scope.peopleWithPositiveAllocations = []
      $scope.peopleWithNegativeAllocations = []
      $scope.newPeople = []
      _.each $scope.people, (person) ->
        if person.allocation_amount > 0
          $scope.peopleWithPositiveAllocations.push(person)
        else if person.allocation_amount < 0
          $scope.peopleWithNegativeAllocations.push(person)
        if person.new_member
          $scope.newPeople.push(person)

    $scope.summedAllocationsFrom = (people) ->
      callback = (sum, person) ->
        sum + Math.abs(parseFloat(person.allocation_amount))
      _.reduce(people, callback, 0)

    return
