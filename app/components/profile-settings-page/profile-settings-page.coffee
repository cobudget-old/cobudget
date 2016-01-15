module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/profile_settings?previous_group_id'
  template: require('./profile-settings-page.html')
  controller: (CurrentUser, $location, Records, $scope, $stateParams, Toast) ->

    $scope.currentUser = CurrentUser()
    previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id

    $scope.changesMade = false

    $scope.back = ->
      $location.search('previous_group_id', null)
      $location.path("/groups/#{previousGroupId}")

    $scope.save = ->
      params = _.pick $scope.currentUser, ['name']
      Records.users.updateProfile(params).then ->
        Toast.show('Profile settings updated!')

    $scope.openChangePasswordDialog = ->
      console.log('openChangePasswordDialog called!')
