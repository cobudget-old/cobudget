module.exports = 
  url: '/'
  template: require('app/components/welcome-page/welcome-page.html')
  controller: ($scope, $auth, Records) ->
    $scope.login = () ->
      $auth.submitLogin({email: 'admin@example.com', password: 'password'})
    $scope.$on 'auth:login-success', (ev, user) -> 
      Records.groups.fetch({})