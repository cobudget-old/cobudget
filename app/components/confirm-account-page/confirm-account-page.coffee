module.exports =
  url: '/confirm_account?confirmation_token'
  template: require('./confirm-account-page.html')
  controller: ($scope, $location, $stateParams, Records, ipCookie, Toast) ->

    $scope.userConfirmingAccount = false

    ipCookie.remove('currentGroupId')
    ipCookie.remove('currentUserId')
    ipCookie.remove('initialRequestPath')

    $scope.confirmationToken = $stateParams.confirmation_token

    $scope.confirmAccount = (formData) ->
      params = 
        name: formData.name        
        password: formData.password
        confirmation_token: $scope.confirmationToken        
      Records.users.confirmAccount(params)
        .then ->
          Toast.show('Your account is set up! Please log in to continue.')
          $location.search('confirmation_token', null)
          $location.path('/')
        .catch ->
          Toast.show('This token has expired. Please log in to continue')
          $location.search('confirmation_token', null)
          $location.path('/')