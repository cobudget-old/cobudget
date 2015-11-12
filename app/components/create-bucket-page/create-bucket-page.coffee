module.exports = 
  resolve: 
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/new'
  template: require('./create-bucket-page.html')
  controller: (CurrentUser, Error, ipCookie, $location, Records, $scope, Toast, $window) ->
    $scope.accessibleGroups = CurrentUser().groups()
    $scope.bucket = Records.buckets.build()

    $scope.cancel = () ->
      if ipCookie('currentGroupId')
        groupId = ipCookie('currentGroupId')
      else
        groupId = CurrentUser().primaryGroup().id

      $location.path("/groups/#{groupId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save().then (data) ->
          bucketId = data.buckets[0].id
          $location.path("/buckets/#{bucketId}")
          Toast.show('You drafted a new bucket')
