module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, CurrentUser) ->
    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin({
        email: formData.email, 
        password: formData.password
      }).then ->
        Records.memberships.fetchMyMemberships()

    $scope.$on 'auth:login-success', (event, user) ->
      Records.users.fetchMe()
      CurrentUser.setId(user.id)
      # TODO: make this go to the first group of the user's groups
      $location.path('/groups/1')

    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"

    return