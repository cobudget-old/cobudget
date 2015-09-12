module.exports = 
  url: '/admin'
  template: require('./admin-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope, config) ->

    $scope.group = Records.groups.build()

    Records.groups.getAll().then (data) ->
      $scope.groups = data.groups

    $scope.createGroup = ->
      if $scope.groupForm.$valid
        $scope.group.save().then (data) ->
          newGroup = data.groups[0]
          $scope.groups.push(newGroup)
          $scope.group = Records.groups.build()
          $scope.groupForm.$setUntouched()

    $scope.uploadPathForGroup = (groupId) ->
      "#{config.apiPrefix}/allocations/upload?group_id=#{groupId}"

    return