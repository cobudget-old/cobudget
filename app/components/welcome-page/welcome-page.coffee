module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope) ->

    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin
        email: formData.email
        password: formData.password

    # TODO: how to put inside .fail callback above?
    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"

    return