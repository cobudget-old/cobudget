module.exports =
  url: '/email_settings?previous_group_id'
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  template: require('./email-settings-page.html')
  reloadOnSearch: false
  controller: (CurrentUser, Dialog, Error, $location, Records, $scope, $stateParams, Toast, UserCan) ->

    if UserCan.changeEmailSettings()
      $scope.authorized = true
      Error.clear()
    else
      $scope.authorized = false
      Error.set("you can't view this page")

    $scope.currentUser = CurrentUser()
    $scope.subscriptionTracker = $scope.currentUser.subscriptionTracker()
    previousGroupId = $stateParams.previous_group_id || CurrentUser().primaryGroup().id

    $scope.emailDigestDeliveryFrequencyOptions = ['never', 'daily', 'weekly']

    $scope.cancel = ->
      $location.search('previous_group_id', null)
      $location.path("/groups/#{previousGroupId}")

    $scope.attemptCancel = (emailSettingsForm) ->
      if emailSettingsForm.$dirty
        Dialog.confirm({title: "Discard unsaved changes?"})
          .then ->
            $scope.cancel()
      else
        $scope.cancel()

    $scope.save = ->
      Records.subscriptionTrackers.updateEmailSettings($scope.subscriptionTracker).then ->
        Toast.show('Email settings updated!')
        $scope.cancel()

    return
