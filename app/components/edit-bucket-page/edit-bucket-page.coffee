module.exports = 
  resolve:
    userValidated: ->
      global.cobudgetApp.userValidated
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/:bucketId/edit'
  template: require('./edit-bucket-page.html')
  controller: ($scope, Records, $stateParams, $location, Toast, UserCan) ->
    
    bucketId = parseInt $stateParams.bucketId

    Records.buckets.findOrFetchById(bucketId)
      .then (bucket) ->
        if UserCan.viewBucket(bucket)
          console.log('user can view bucket')
          $scope.bucket = bucket
        else
          console.log('user can not view bucket')
      .catch ->
        console.log('bucket does not exist')
        
    $scope.cancel = () ->
      $location.path("/buckets/#{bucketId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save()
        Toast.show('Your edits have been saved')
        $scope.cancel()