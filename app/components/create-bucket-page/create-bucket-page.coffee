module.exports = 
  url: '/buckets/new'
  template: require('./create-bucket-page.html')
  resolve: 
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  controller: ($scope, Records, $location, Toast) ->

    groupId = global.cobudgetApp.currentGroupId

    $scope.bucket = Records.buckets.build()
    $scope.bucket.groupId = groupId

    Records.groups.findOrFetchById(groupId).then (group) ->
      $scope.group = group
      
    $scope.cancel = () ->
      $location.path("/groups/#{groupId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save().then (data) ->
          bucketId = data.buckets[0].id
          $location.path("/buckets/#{bucketId}")
          Toast.show('You drafted a new bucket')