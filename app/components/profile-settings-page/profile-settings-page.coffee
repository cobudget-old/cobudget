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
    $scope.passwordParams = {}

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
            $scope.unsavedFields = ->
              fields = []
              if $scope.accountDetailsForm.name.$dirty
                fields.push('name')
              if !isEmptyObject($scope.passwordParams)
                fields.push('password')
              listify(_.map(fields, (field) -> "<b>#{field}</b>"))
      else
        $scope.back()

    $scope.openPasswordFields = ->
      $scope.showPasswordFields = true

    $scope.closePasswordFields = ->
      $scope.passwordParams = {}
      $scope.passwordErrors = {}
      $scope.showPasswordFields = false
      _.each ['current_password', 'password', 'confirm_password'], (fieldName) ->
        $scope.accountDetailsForm[fieldName].$setPristine()
      if $scope.accountDetailsForm.name.$pristine
        $scope.accountDetailsForm.$setPristine()

    $scope.save = ->
      $scope.formSubmitted = true
      promises = []
      if $scope.accountDetailsForm.name.$dirty
        promises.push($scope.updateProfile())
      if $scope.showPasswordFields
        promises.push($scope.savePassword())
      $q.allSettled(promises)
        .then ->
          formSubmitted = false
        .finally ->
          resolvedPromises = _.filter promises, (promise) ->
            promise.$$state.status == 1
          updatedFields = _.map resolvedPromises, (promise) ->
            promise.$$state.value
          if updatedFields.length > 0
            Toast.show("Your new #{listify(updatedFields)} #{if updatedFields.length > 1 then 'were' else 'was'} saved")

    $scope.updateProfile = ->
      deferred = $q.defer()
      profileParams = _.pick $scope.currentUser, ['name']
      Records.users.updateProfile(profileParams)
        .then ->
          deferred.resolve('name')
        .catch ->
          deferred.reject()
      deferred.promise

    $scope.savePassword = ->
      deferred = $q.defer()
      $scope.passwordErrors = {}
      Records.users.updatePassword($scope.passwordParams)
        .then (res) ->
          $scope.closePasswordFields()
          deferred.resolve('password')
        .catch (err) ->
          if err.status == 401
            $scope.passwordErrors.currentPassword = 'Sorry, we couldn\'t confirm your current password.'
            $scope.passwordParams.current_password = ""
          else if err.status == 400
            $scope.passwordErrors.newPassword = 'Sorry, your repeated new password didn\'t match.'
            $scope.passwordParams.password = ""
            $scope.passwordParams.confirm_password = ""
          deferred.reject()
      deferred.promise
