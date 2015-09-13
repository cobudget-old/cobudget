module.exports = 
  url: '/admin'
  template: require('./admin-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope, config) ->

    $scope.currencies = [
      { code: 'USD', symbol: '$' },
      { code: 'NZD', symbol: '$' },
      { code: 'EUR', symbol: '€' }
    ]

    Records.groups.getAll().then (groups) ->
      $scope.groups = groups

    $scope.group = Records.groups.build()

    $scope.createGroup = ->
      if $scope.groupForm.$valid
        $scope.group.save().then (data) ->
          newGroup = data.groups[0]
          $scope.groups.push(newGroup)
          $scope.group = Records.groups.build()
          $scope.groupForm.$setUntouched()

    $scope.uploadPathForGroup = (groupId) ->
      "#{config.apiPrefix}/allocations/upload?group_id=#{groupId}"

    $scope.onCsvUploadSuccess = (groupId) ->
      Records.groups.findOrFetchById(groupId).then (updatedGroup) ->
        updatedGroupIndex = _.findIndex $scope.groups, (group) ->
          group.id == groupId
        $scope.groups[updatedGroupIndex] = updatedGroup

    return