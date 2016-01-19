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

    $scope.openPasswordFields = ->
      $scope.showPasswordFields = true

    $scope.closePasswordFields = ->
      $scope.passwordParams = {}
      $scope.passwordErrors = {}
      $scope.showPasswordFields = false

    $scope.save = ->
      $scope.formSubmitted = true
      promises = []
      changes = []
      if $scope.accountDetailsForm.name.$dirty
        promises.push($scope.updateProfile())
        changes.push('name')
      if $scope.showPasswordFields
        promises.push($scope.savePassword())
        changes.push('password')
      $q.all(promises).then ->
        Toast.show("Your new #{changes.join(' and ')} #{if changes.length > 1 then 'were' else 'was'} saved")

    $scope.updateProfile = ->
      profileParams = _.pick $scope.currentUser, ['name']
      Records.users.updateProfile(profileParams)

    $scope.savePassword = ->
      $scope.passwordErrors = {}
      deferred = $q.defer()
      promise = deferred.promise
      Records.users.updatePassword($scope.passwordParams)
        .then (res) ->
          deferred.resolve()
          $scope.closePasswordFields()
        .catch (err) ->
          deferred.reject()
          if err.status == 401
            $scope.passwordErrors.currentPassword = 'Sorry, we couldn\'t confirm your current password.'
            $scope.passwordParams.current_password = ""
          else if err.status == 400
            $scope.passwordErrors.newPassword = 'Sorry, your repeated new password didn\'t match.'
            $scope.passwordParams.password = ""
            $scope.passwordParams.confirm_password = ""
      promise
