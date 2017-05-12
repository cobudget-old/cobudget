module.exports =
  onExit: ($location) ->
    $location.url($location.path())
  resolve:
    clearSession: (Session) ->
      Session.clear()
  url: '/confirm_account?confirmation_token&setup_group'
  template: require('./confirm-account-page.html')
  reloadOnSearch: false
  controller: ($scope, $auth, LoadBar, $location, $stateParams, Records, Session, Toast) ->
    $scope.confirmationToken = $stateParams.confirmation_token
    $scope.setupGroup = $stateParams.setup_group

    $scope.confirmAccount = (formData) ->
      LoadBar.start()
      params =
        name: formData.name
        password: formData.password
        confirmation_token: $scope.confirmationToken
      Records.users.confirmAccount(params)
        .then (data) ->
          loginParams = { email: data.users[0].email, password: formData.password }
          if $scope.setupGroup
            Session.create(loginParams).then ->
              $location.path("/setup_group")
          else
            Session.create(loginParams, {redirectTo: 'group'})
        .catch ->
          Toast.show('Sorry, that confirmation token has expired.')
          $location.path('/')
