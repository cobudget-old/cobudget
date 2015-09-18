module.exports = 
  url: '/groups/:groupId'
  template: require('./group-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, Toast, $window) ->

    $scope.fetchData = ->
      $scope.contributionsLoaded = $scope.commentsLoaded = $scope.membershipsLoaded = false

      groupId = parseInt($stateParams.groupId)
      global.cobudgetApp.currentGroupId = groupId
      $scope.currentUserId = CurrentUser().id
      
      Records.groups.findOrFetchById(groupId).then (group) ->
        $scope.group = group
        $scope.currentMembership = group.membershipFor(CurrentUser())
        Records.buckets.fetchByGroupId(group.id).then (data) ->
          _.each data.buckets, (bucket) ->
            Records.contributions.fetchByBucketId(bucket.id).then ->
              $scope.contributionsLoaded = true
            Records.comments.fetchByBucketId(bucket.id).then ->
              $scope.commentsLoaded = true
        Records.memberships.fetchByGroupId(group.id).then ->
          $scope.membershipsLoaded = true

    if global.cobudgetApp.currentUserId
      console.log('[group-page] CurrentUser() exists!')
      Records.memberships.fetchMyMemberships().then ->
        console.log('[group-page] memberships being fetched!')
        $scope.fetchData()
        console.log('[group-page] data is being fetched, and the page is loading')
    else
      console.log('[group-page] CurrentUser() not found')
      global.cobudgetApp.initialRequestPath = $location.path()
      console.log('[group-page] global.cobudgetApp.initialRequestPath set to: ', global.cobudgetApp.initialRequestPath)
      Toast.show('You must sign in to continue')
      console.log('[group-page] redirecting to "/"')
      $location.path('/')

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

    return