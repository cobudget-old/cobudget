module.exports = 
  url: '/admin'
  template: require('./admin-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope) ->

    $scope.group = Records.groups.build()

    Records.groups.getAll().then (data) ->
      $scope.groups = data.groups

    $scope.createGroup = ->
      if $scope.groupForm.$valid
        $scope.group.save().then ->
          $scope.group = Records.groups.build()
          $scope.groupForm.$setUntouched()

    return