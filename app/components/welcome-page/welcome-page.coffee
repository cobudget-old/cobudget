module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, ipCookie) ->

    $scope.userSigningIn = false

    $scope.login = (formData) ->
      $scope.formError = ""
      $scope.userSigningIn = true
      $auth.submitLogin
        email: formData.email
        password: formData.password

    $scope.redirectToGroupPage = (user) ->
      ipCookie('currentUserId', user.id)
      if ipCookie('initialRequestPath') == undefined || ipCookie('initialRequestPath') == '/'
        Records.memberships.fetchMyMemberships().then (data) ->
          ipCookie('currentGroupId', data.groups[0].id)
          $location.path("/groups/#{ipCookie('currentGroupId')}")
      else
        $location.path(ipCookie('initialRequestPath'))
        ipCookie.remove('initialRequestPath')

    $scope.$on 'auth:validation-success', (event, user) ->
      $scope.userSigningIn = true 
      $scope.redirectToGroupPage(user)

    $scope.$on 'auth:login-success', (event, user) ->
      $scope.redirectToGroupPage(user)

    $scope.$on 'auth:login-error', ->
      $scope.formError = "Invalid Credentials"
      $scope.userSigningIn = false

    return