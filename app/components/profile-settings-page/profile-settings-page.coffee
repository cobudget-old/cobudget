module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/profile_settings?previous_group_id'
  template: require('./profile-settings-page.html')
  controller: (CurrentUser, Dialog, $location, $q, Records, $scope, $stateParams, Toast, $window) ->
    $scope.currentUser = CurrentUser()
    previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id

    $scope.back = ->
        $location.search('previous_group_id', null)
        $location.path("/groups/#{previousGroupId}")

    $scope.attemptBack = ->
      if $scope.accountDetailsForm.$dirty
        Dialog.custom
          scope: $scope
          template: require('./discard-changes-dialog.tmpl.html')
          controller: ($mdDialog, $scope) ->
            $scope.cancel = ->
              $mdDialog.cancel()
            $scope.okay = ->
              $mdDialog.cancel()
              $scope.back()
      else
        $scope.back()

    $scope.save = ->
      params = _.pick $scope.currentUser, ['name']
      Records.users.updateProfile(params).then ->
        $scope.changesMade = false
        Toast.show('Profile settings updated!')

    $scope.openPasswordFields = ->
      $scope.showPasswordFields = true

    $scope.closePasswordFields = ->
      $scope.showPasswordFields = false
