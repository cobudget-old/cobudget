module.exports =
  resolve:
    userValidated: ($auth) ->
      $auth.validateUser()
    membershipsLoaded: ->
      global.cobudgetApp.membershipsLoaded
  url: '/users/:userId?previous_bucket_id'
  template: require('./user-page.html')
  controller: (CurrentUser, Error, $location, Records, $scope, $stateParams) ->

    userId = parseInt($stateParams.userId)

    Records.users.fetchUserById(userId)
      .then (data) ->
        $scope.user = data.user
      .catch ->
        Error.set('user not found')

    return
