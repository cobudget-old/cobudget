module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/groups/:groupId/settings'
  template: require('./admin-page.html')
  controller: (CurrentUser, Error, Dialog, $location, Records, $scope, UserCan, Toast, $stateParams, Currencies) ->

    groupId = parseInt($stateParams.groupId)

    Records.groups.findOrFetchById(groupId)
      .then (group) ->
        if CurrentUser().isAdminOf(group)
          $scope.authorized = true
          Error.clear()
          $scope.group = group
        else
          $scope.authorized = false
          Error.set("you can't view this page")
      .catch (err) ->
        Sentry?.captureException(err, "groupId: #{groupId}");
        Toast.show('group not found')

    $scope.currencies = Currencies()

    $scope.updateGroup = () ->
      $scope.group.save()
        .then ->
          Toast.show('You updated ' + $scope.group.name)
          $scope.cancel()

    $scope.viewGroup = (groupId) ->
      $location.path("/groups/#{groupId}")

    $scope.cancel = () ->
      $location.path("/groups/#{groupId}")

    $scope.attemptCancel = (adminPageForm) ->
      if adminPageForm.$dirty
        Dialog.confirm({title: "Discard unsaved changes?"})
          .then ->
            $scope.cancel()
      else
        $scope.cancel()

    return
