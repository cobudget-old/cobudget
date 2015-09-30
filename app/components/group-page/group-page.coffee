module.exports = 
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location, $window, ipCookie, AuthenticateUser, $auth, Toast, $mdSidenav, VerifyUserPermissions) ->
    $scope.accessibleGroupsLoaded = $scope.contributionsLoaded = $scope.commentsLoaded = $scope.membershipsLoaded = false

    AuthenticateUser().then (currentUser) ->
      groupId = parseInt($stateParams.groupId)
      $scope.currentUser = currentUser

      VerifyUserPermissions.forGroup(groupId)
        .then (group) ->
          $scope.group = group
          $scope.fetchRecords()
        .catch ->
          $scope.unauthorized = true

    $scope.fetchRecords = ->
      # 1. get accessible groups
      Records.memberships.fetchMyMemberships().then (data) ->
        $scope.accessibleGroupsLoaded = true
        $scope.accessibleGroups = data.groups

        # 2. get current membership
        $scope.currentMembership = $scope.group.membershipFor($scope.currentUser)

        # 3. get buckets
        Records.buckets.fetchByGroupId($scope.group.id).then (data) ->
          if data.buckets.length > 0
            # 4. get comments and contributions for buckets if they exist
            _.each data.buckets, (bucket) ->
              Records.contributions.fetchByBucketId(bucket.id).then ->
                $scope.contributionsLoaded = true
              Records.comments.fetchByBucketId(bucket.id).then ->
                $scope.commentsLoaded = true
          else 
            $scope.contributionsLoaded = $scope.commentsLoaded = true

        # 5. get funders
        Records.memberships.fetchByGroupId($scope.group.id).then ->
          $scope.membershipsLoaded = true

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
          ipCookie.remove('currentGroupId')
          ipCookie.remove('currentUserId')
          ipCookie.remove('initialRequestPath')
          $location.path('/')

    $scope.openSidenav = ->
      $mdSidenav('left').open()

    $scope.redirectToGroupPage = (groupId) ->
      if $scope.group.id == parseInt(groupId)
        $mdSidenav('left').close()
      else
        $location.path("/groups/#{groupId}")

    return