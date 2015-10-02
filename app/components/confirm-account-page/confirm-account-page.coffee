module.exports =
  url: '/confirm_account?confirmation_token'
  template: require('./confirm-account-page.html')
  controller: ($scope, $auth, $location, $stateParams, Records, ipCookie, Toast) ->

    $scope.userConfirmingAccount = false
    $scope.confirmationToken = $stateParams.confirmation_token

    $scope.confirmAccount = (formData) ->
      $location.search('confirmation_token', null)
      ipCookie.remove('currentUserId')

      $scope.userConfirmingAccount = true
      params = 
        name: formData.name        
        password: formData.password
        confirmation_token: $scope.confirmationToken        
      Records.users.confirmAccount(params)
        .then (data) ->
          user = data.users[0]
          ipCookie('currentUserId', user.id)
          loginParams = { email: user.email, password: formData.password }
          $auth.submitLogin(loginParams)
            .then ->
              Toast.show('Your account is set up! Welcome to Cobudget!')
              group = data.groups[0]
              ipCookie('currentGroupId', group.id)
              $location.path("/groups/#{group.id}")
            .catch ->
              Toast.show('Sorry, that confirmation token has expired.')
              $location.path('/')