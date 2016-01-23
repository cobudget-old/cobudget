module.exports =
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
          user = data.users[0]
          global.cobudgetApp.currentUserId = user.id
          loginParams = { email: user.email, password: formData.password }
          $auth.submitLogin(loginParams)
            .then (ev, user) ->
              $location.search('confirmation_token', null)
              $location.search('setup_group', null)
              if $scope.setupGroup
                $location.path("/setup_group")
        .catch ->
            Toast.show('Sorry, that confirmation token has expired.')
            $location.path('/')
