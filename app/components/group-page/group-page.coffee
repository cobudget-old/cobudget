module.exports =
  resolve:
    userValidated: ->
      global.cobudgetApp.userValidated
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded

  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, $stateParams, $location, $window, $auth, Toast, $mdSidenav, UserCan, FetchRecordsFor) ->

    groupId = parseInt($stateParams.groupId)

    console.log("i've loaded!!!!!!!!")

    if UserCan.viewGroup(groupId)
      console.log("user CAN view group")
      FetchRecordsFor.groupPage(groupId).then (data) ->
        $scope.accessibleGroups = data.accessibleGroups
        $scope.group = data.group
        $scope.currentMembership = data.currentMembership
        $scope.currentUser = data.currentUser
        $scope.recordsLoaded = true
    else
      console.log("user CANNOT view group")
      $scope.unauthorized = true

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