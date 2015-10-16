module.exports = 
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/:bucketId'
  template: require('./bucket-page.html')
  controller: ($scope, Records, $stateParams, $location, Toast, UserCan, CurrentUser, Error, $window) ->

    bucketId = parseInt $stateParams.bucketId
    Records.buckets.findOrFetchById(bucketId)
      .then (bucket) -> 
        if UserCan.viewBucket(bucket)
          $scope.authorized = true
          Error.clear()
          $scope.currentUser = CurrentUser()
          $scope.bucket = bucket
          $scope.group = bucket.group()
          $scope.membership = Records.memberships.find(groupId: $scope.group.id, memberId: CurrentUser().id)[0]
          Records.contributions.fetchByBucketId(bucketId)
          Records.comments.fetchByBucketId(bucketId)
          $scope.recordsLoaded = true
        else
          $scope.authorized = false
          Error.set('cannot view bucket')
      .catch ->
        Error.set('bucket not found')

    $scope.newComment = Records.comments.build(bucketId: bucketId)
    $scope.newContribution = Records.contributions.build(bucketId: bucketId)

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
        
    return
