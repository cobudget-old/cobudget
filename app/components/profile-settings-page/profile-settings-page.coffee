module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/profile_settings?previous_group_id'
  template: require('./profile-settings-page.html')
  controller: (CurrentUser, Dialog, $location, Records, $scope, $stateParams, Toast, $window) ->
    $scope.currentUser = CurrentUser()
    previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id
    $scope.changesMade = false

    $scope.back = ->
        $location.search('previous_group_id', null)
        $location.path("/groups/#{previousGroupId}")

    $scope.attemptBack = ->
      if $scope.changesMade
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
        Toast.show('Profile settings updated!')

    $scope.openChangePasswordDialog = ->
      Dialog.custom
        scope: $scope
        template: require('./change-password-dialog.tmpl.html')
        controller: ($mdDialog, $scope, Toast) ->
          $scope.formParams = {}
          $scope.formSubmitted = false
          
          $scope.savePassword = ->
            $scope.errors = {}

            Records.users.updatePassword($scope.formParams)
              .then (res) ->
                Toast.show('Your new password was saved')
                $mdDialog.cancel()
              .catch (err) ->
                if err.status == 401
                  $scope.errors.currentPassword = 'Sorry, we couldn\'t confirm your current password.'
                  $scope.formParams.current_password = ""
                else if err.status == 400
                  $scope.errors.newPassword = 'Sorry, your repeated new password didn\'t match.'
                  $scope.formParams.password = ""
                  $scope.formParams.confirm_password = ""
          $scope.cancel = ->
            $mdDialog.cancel()
