module.exports = 
  resolve: 
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/buckets/new?group_id'
  template: require('./create-bucket-page.html')
  controller: (config, CurrentUser, Error, $location, Records, $scope, $stateParams, Toast, $window) ->
    $scope.accessibleGroups = CurrentUser().groups()
    $scope.bucket = Records.buckets.build(groupId: $stateParams.group_id)

    if $scope.accessibleGroups.length == 1
      $scope.bucket.groupId = CurrentUser().primaryGroup().id

    $scope.cancel = () ->
      $location.search('group_id', null)
      if $scope.bucket.groupId
        groupId = $scope.bucket.groupId
      else
        groupId = CurrentUser().primaryGroup().id

      $location.path("/groups/#{groupId}")

    $scope.done = () ->
      $scope.formSubmitted = true
      if $scope.bucketForm.$valid
        $scope.bucket.save().then (data) ->
          $location.search('group_id', null)
          bucketId = data.buckets[0].id
          $location.path("/buckets/#{bucketId}")
          Toast.show('You drafted a new bucket')
