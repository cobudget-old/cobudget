module.exports =
  url: '/confirm_account?confirmation_token'
  template: require('./confirm-account-page.html')
  controller: ($scope, $auth, LoadBar, $location, $stateParams, Records, Toast) ->

    $scope.confirmationToken = $stateParams.confirmation_token

    $scope.confirmAccount = (formData) ->
      LoadBar.start()
      $location.search('confirmation_token', null)

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
        .catch ->
          Toast.show('Sorry, that confirmation token has expired.')
          $location.path('/')