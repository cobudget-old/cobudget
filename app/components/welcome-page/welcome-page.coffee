module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records) ->
    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin({
        email: formData.email, 
        password: formData.password
      }).then (user) ->
        $location.path('/groups/1')

    # TODO: how to put inside .fail callback above?
    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"

    return