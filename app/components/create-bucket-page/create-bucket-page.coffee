module.exports = 
  url: '/buckets/new'
  template: require('./create-bucket-page.html')
  controller: ($scope, Records, $location, Toast, ipCookie) ->
    
    $scope.groupLoaded = false
    groupId = ipCookie('currentGroupId')
    $scope.bucket = Records.buckets.build(groupId: groupId)

    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      $scope.groupLoaded = true
      
    $scope.cancel = () ->
      $location.path("/groups/#{groupId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save().then (data) ->
          bucketId = data.buckets[0].id
          $location.path("/buckets/#{bucketId}")
          Toast.show('You drafted a new bucket')