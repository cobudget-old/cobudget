module.exports = 
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/:bucketId/edit'
  template: require('./edit-bucket-page.html')
  controller: ($scope, Records, $stateParams, $location, Toast, UserCan, Error) ->
    
    bucketId = parseInt $stateParams.bucketId

    Records.buckets.findOrFetchById(bucketId)
      .then (bucket) ->
        if UserCan.viewBucket(bucket)
          $scope.authorized = true
          Error.clear()
          $scope.bucket = bucket
        else
          $scope.authorized = false
          Error.set('cannot view bucket')
      .catch ->
        Error.set('bucket not found')
        
    $scope.cancel = () ->
      $location.path("/buckets/#{bucketId}")

    $scope.done = (bucketForm) ->
      if bucketForm.$valid
        $scope.bucket.save()
        Toast.show('Your edits have been saved')
        $scope.cancel()