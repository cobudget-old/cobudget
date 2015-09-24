module.exports =
  url: '/confirm_account?confirmation_token'
  template: require('./confirm-account-page.html')
  controller: ($scope, $location, $stateParams, Records, ipCookie, Toast) ->

    $scope.userConfirmingAccount = false
    $scope.confirmationToken = $stateParams.confirmation_token

    $scope.redirectToLogin = () ->
      $location.search('confirmation_token', null)
      ipCookie.remove('currentUserId')
      $location.path('/')

    $scope.confirmAccount = (formData) ->
      params = 
        name: formData.name        
        password: formData.password
        confirmation_token: $scope.confirmationToken        
      Records.users.confirmAccount(params)
        .then ->
          Toast.show('Your account is set up! Please log in to continue.')
          $scope.redirectToLogin()
        .catch ->
          Toast.show('This token has expired. Please log in to continue')
          $scope.redirectToLogin()
