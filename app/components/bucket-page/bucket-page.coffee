module.exports = 
  url: '/buckets/:bucketId'
  template: require('./bucket-page.html')
  controller: ($scope, Records, $stateParams, $location, CurrentUser, Toast) ->
    $scope.groupLoaded = $scope.contributionsLoaded = $scope.commentsLoaded = false

    $scope.fetchData = ->
      $scope.groupId = global.cobudgetApp.currentGroupId
      $scope.bucketId = parseInt $stateParams.bucketId

      Records.groups.findOrFetchById($scope.groupId).then (group) ->
        $scope.group = group
        $scope.groupLoaded = true
        $scope.currentMembership = group.membershipFor(CurrentUser())

      Records.buckets.findOrFetchById($scope.bucketId).then (bucket) ->
        $scope.bucket = bucket
        $scope.status = bucket.status
        Records.contributions.fetchByBucketId($scope.bucketId).then ->
          $scope.percentContributedByUser = bucket.percentContributedByUser(CurrentUser().id)
          $scope.percentNotContributedByUser = bucket.percentNotContributedByUser(CurrentUser().id)
          $scope.contributionsLoaded = true
        Records.comments.fetchByBucketId($scope.bucketId).then ->
          $scope.commentsLoaded = true

      $scope.newComment = Records.comments.build(bucketId: $scope.bucketId)
      $scope.contribution = Records.contributions.build(bucketId: $scope.bucketId)

    if global.cobudgetApp.currentUserId
      console.log('[bucket-page] CurrentUser() exists!')
      Records.memberships.fetchMyMemberships().then (data) ->
        if !global.cobudgetApp.currentGroupId
          console.log('[bucket-page] global.cobudgetApp.currentGroupId not set')
          global.cobudgetApp.currentGroupId = data.groups[0].id
          console.log('[bucket-page] global.cobudgetApp.currentGroupId set to: ', global.cobudgetApp.currentGroupId)

        console.log('[bucket-page] memberships being fetched!')
        $scope.fetchData()
        console.log('[bucket-page] data is being fetched, and the page is loading')
    else
      console.log('[bucket-page] CurrentUser() not found')
      global.cobudgetApp.initialRequestPath = $location.path()
      console.log('[bucket-page] global.cobudgetApp.initialRequestPath set to: ', global.cobudgetApp.initialRequestPath)
      Toast.show('You must sign in to continue')
      console.log('[bucket-page] redirecting to "/"')
      $location.path('/')

    $scope.back = ->
      Toast.hide()
      $location.path("/groups/#{$scope.groupId}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.createComment = ->
      $scope.newComment.save()
      $scope.newComment = Records.comments.build(bucketId: $scope.bucketId)

    $scope.userCanStartFunding = ->
      $scope.currentMembership.isAdmin || $scope.bucket.author().id == $scope.currentMembership.member().id

    $scope.openForFunding = ->
      if $scope.bucket.target
        $scope.bucket.openForFunding().then ->
          $scope.back()
          Toast.showWithRedirect('You launched a bucket for funding', "/buckets/#{$scope.bucketId}")
      else
        alert('Estimated funding target must be specified before funding starts')        

    $scope.editBucket = ->
      $location.path("/buckets/#{$scope.bucketId}/edit")

    $scope.userCanEditBucket = ->
      $scope.bucket && $scope.userCanStartFunding()

    $scope.openFundForm = ->
      $scope.fundFormOpened = true

    $scope.totalAmountFunded = ->
      parseFloat($scope.bucket.totalContributions) + ($scope.contribution.amount || 0)

    $scope.percentContributed = ->
      ($scope.contribution.amount || 0) / $scope.bucket.target * 100

    $scope.maxAllowableContribution = ->
      _.min([$scope.bucket.amountRemaining(), $scope.currentMembership.balance()])

    $scope.normalizeContributionAmount = ->
      if $scope.contribution.amount > $scope.maxAllowableContribution()
        $scope.contribution.amount = $scope.maxAllowableContribution()

    $scope.submitContribution = ->
      $scope.contribution.save().then ->
        $scope.back()
        Toast.show('You funded a bucket')
        
    return