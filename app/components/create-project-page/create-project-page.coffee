module.exports = 
  url: '/projects/new'
  template: require('./create-project-page.html')
  controller: ($scope, Records, $location, Toast) ->

    groupId = global.cobudgetApp.currentGroupId

    $scope.bucket = Records.buckets.build()
    $scope.bucket.groupId = groupId
      
    $scope.cancel = () ->
      $location.path("/groups/#{groupId}")

    $scope.done = () ->
      if $scope.bucketForm.$valid
        $scope.bucket.save().then (data) ->
          projectId = data.buckets[0].id
          $location.path("/projects/#{projectId}")
          Toast.show('You drafted a new project')