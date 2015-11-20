# (EL) NOTE: may want to use this as an 'edit group' page in the future
# http://i.imgur.com/RMs4njZ.gifv

module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/setup'
  template: require('./group-setup-page.html')
  controller: (Error, LoadBar, $location, Records, $scope, $stateParams, UserCan) ->
    LoadBar.start()
    groupId = parseInt($stateParams.groupId)
    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        $scope.group = group
        if UserCan.viewGroup(group)
          $scope.authorized = true
          LoadBar.stop()
        else
          $scope.authorized = false
          LoadBar.stop()
          Error.set("you can't view this page")
      .catch ->
        LoadBar.stop()
        Error.set('group not found')

    $scope.setupGroup = (formData) ->
      $scope.group.name = formData.name
      $scope.group.save().then ->
        $location.path("/groups/#{$scope.group.id}")        