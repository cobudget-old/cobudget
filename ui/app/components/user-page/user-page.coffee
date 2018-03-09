module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/users/:userId'
  template: require('./user-page.html')
  controller: (CurrentUser, Error, $location, Records, $scope, $stateParams, LoadBar) ->

    LoadBar.start()

    userId = parseInt($stateParams.userId)

    Records.users.fetchUserById(userId)
      .then (data) ->
        LoadBar.stop()
        $scope.user = data.user
      .catch ->
        Error.set('user not found')

    return
