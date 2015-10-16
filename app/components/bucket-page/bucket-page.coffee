module.exports = 
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/:bucketId'
  template: require('./bucket-page.html')
  controller: (CurrentUser, Error, LoadBar, $location, Records, $scope, $stateParams, Toast, UserCan, $window) ->

    LoadBar.start()
    bucketId = parseInt $stateParams.bucketId
    Records.buckets.findOrFetchById(bucketId)
      .then (bucket) ->
        if UserCan.viewBucket(bucket)
          $scope.authorized = true
          Error.clear()
          $scope.currentUser = CurrentUser()
          $scope.bucket = bucket
          $scope.group = bucket.group()
          $scope.membership = $scope.group.membershipFor(CurrentUser())
          Records.contributions.fetchByBucketId(bucketId).then ->
            $window.scrollTo(0,0)
            LoadBar.stop()
          Records.comments.fetchByBucketId(bucketId)
        else
          $scope.authorized = false
          LoadBar.stop()
          Error.set('cannot view bucket')
      .catch ->
        LoadBar.stop()
        Error.set('bucket not found')

    $scope.newContribution = Records.contributions.build(bucketId: bucketId)

    $scope.back = ->
      Toast.hide()
      $location.path("/groups/#{$scope.group.id}")

    return
