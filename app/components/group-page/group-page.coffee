module.exports =
  resolve:
    userValidated: ->
      global.cobudgetApp.userValidated
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($rootScope, $scope, $stateParams, $location, Records, $window, $auth, Toast, UserCan, CurrentUser, Error) ->
    console.log('group page loaded')

    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if UserCan.viewGroup(group)
          Error.clear()
          console.log('user can view group')
          $scope.group = group
          $scope.currentUser = CurrentUser()
          $scope.membership = group.membershipFor(CurrentUser())
          Records.memberships.fetchByGroupId(groupId)
          Records.buckets.fetchByGroupId(groupId)
          Records.contributions.fetchByGroupId(groupId)
        else
          Error.set('cannot view group')
      .catch ->
        Error.set('group not found')

    $scope.createBucket = ->
      $location.path("/buckets/new")

    $scope.showBucket = (bucketId) ->
      $location.path("/buckets/#{bucketId}")

    $scope.selectTab = (tabNum) ->
      $scope.tabSelected = parseInt tabNum

    $scope.openAdminPanel = ->
      $location.path("/admin")

    $scope.openFeedbackForm = ->
      $window.location.href = 'https://docs.google.com/forms/d/1-_zDQzdMmq_WndQn2bPUEW2DZQSvjl7nIJ6YkvUcp0I/viewform?usp=send_form';

    $scope.signOut = ->
       $auth.signOut().then ->
          Toast.show("You've been signed out")
          global.cobudgetApp.currentUserId = null
          $location.path('/')

    $scope.openSidenav = ->
      $mdSidenav('left').open()

    $scope.redirectToGroupPage = (groupId) ->
      if $scope.group.id == parseInt(groupId)
        $mdSidenav('left').close()
      else
        $location.path("/groups/#{groupId}")

    return