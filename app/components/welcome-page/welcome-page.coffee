module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location) ->
    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin({
        email: formData.email, 
        password: formData.password
      })

    $scope.$on 'auth:login-success', () ->
      $location.path('/groups/1')

    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"