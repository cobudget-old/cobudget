module.exports = 
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/:bucketId'
  template: require('./bucket-page.html')
  controller: (CurrentUser, Error, $location, Records, $scope, $stateParams, Toast, UserCan) ->

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
        else
          $scope.authorized = false
          Error.set('cannot view bucket')
      .catch ->
        Error.set('bucket not found')

    $scope.newContribution = Records.contributions.build(bucketId: bucketId)

    $scope.back = ->
      Toast.hide()
      $location.path("/groups/#{$scope.group.id}")

    return
