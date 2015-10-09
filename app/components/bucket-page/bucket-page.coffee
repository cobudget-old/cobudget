module.exports = 
  resolve:
    userValidated: ->
      global.cobudgetApp.userValidated
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/:bucketId'
  template: require('./bucket-page.html')
  controller: ($scope, $state, Records, $stateParams, $location, Toast, UserCan, CurrentUser) ->
    console.log('bucket page loaded')

    bucketId = parseInt $stateParams.bucketId
    Records.buckets.findOrFetchById(bucketId)
      .then (bucket) -> 
        if UserCan.viewBucket(bucket)
          console.log('user can view bucket')
          $scope.currentUser = CurrentUser()
          $scope.bucket = bucket
          $scope.group = bucket.group()
          $scope.membership = Records.memberships.find(groupId: $scope.group.id, memberId: CurrentUser().id)[0]
          Records.contributions.fetchByBucketId(bucketId)
          Records.comments.fetchByBucketId(bucketId)
          $scope.recordsLoaded = true
        else
          console.log('user can not view bucket')
      .catch ->
        console.log('bucket does not exist')

    $scope.newComment = Records.comments.build(bucketId: bucketId)
    $scope.newContribution = Records.contributions.build(bucketId: bucketId)
      
    $scope.back = ->
      Toast.hide()
      $location.path("/groups/#{$scope.group.id}")

    $scope.showFullDescription = false

    $scope.readMore = ->
      $scope.showFullDescription = true

    $scope.showLess = ->
      $scope.showFullDescription = false

    $scope.createComment = ->
      $scope.newComment.save()
      $scope.newComment = Records.comments.build(bucketId: bucketId)

    $scope.userCanStartFunding = ->
      $scope.recordsLoaded && ($scope.membership.isAdmin ||  $scope.bucket.author().id == $scope.membership.member().id)

    $scope.openForFunding = ->
      if $scope.bucket.target
        $scope.bucket.openForFunding().then ->
          $scope.back()
          Toast.showWithRedirect('You launched a bucket for funding', "/buckets/#{bucketId}")
      else
        alert('Estimated funding target must be specified before funding starts')        

    $scope.editBucket = ->
      $location.path("/buckets/#{bucketId}/edit")

    $scope.userCanEditBucket = ->
      $scope.bucket && $scope.userCanStartFunding()

    $scope.openFundForm = ->
      $scope.fundFormOpened = true

    $scope.totalAmountFunded = ->
      parseFloat($scope.bucket.totalContributions) + ($scope.newContribution.amount || 0)

    $scope.percentContributed = ->
      ($scope.newContribution.amount || 0) / $scope.bucket.target * 100

    $scope.maxAllowableContribution = ->
      _.min([$scope.bucket.amountRemaining(), $scope.membership.balance()])

    $scope.normalizeContributionAmount = ->
      if $scope.newContribution.amount > $scope.maxAllowableContribution()
        $scope.newContribution.amount = $scope.maxAllowableContribution()

    $scope.submitContribution = ->
      $scope.newContribution.save().then ->
        $state.reload()
        Toast.show('You funded a bucket')
        
    return
