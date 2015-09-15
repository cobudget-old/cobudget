module.exports = 
  url: '/buckets/:bucketId/edit'
  template: require('./edit-bucket-page.html')
  resolve: 
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  controller: ($scope, Records, $stateParams, $location, Toast) ->
    bucketId = parseInt $stateParams.bucketId

    Records.buckets.findOrFetchById(bucketId).then (bucket) ->
      $scope.bucket = bucket
      # temp hack to get around target form number validation
      $scope.bucket.target = parseInt $scope.bucket.target
            
    $scope.cancel = () ->
      $location.path("/buckets/#{bucketId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save()
        Toast.show('Your edits have been saved')
        $scope.cancel()