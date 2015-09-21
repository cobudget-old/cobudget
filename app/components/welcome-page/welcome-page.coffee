module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, $rootScope, ipCookie) ->

    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin
        email: formData.email
        password: formData.password

    $scope.redirectToGroupPage = (user) ->
      ipCookie('currentUserId', user.id)
      if ipCookie('initialRequestPath') == undefined || ipCookie('initialRequestPath') == '/'
        Records.memberships.fetchMyMemberships().then (data) ->
          if !ipCookie('currentGroupId')
            ipCookie('currentGroupId', data.groups[0].id)
          $location.path("/groups/#{ipCookie('currentGroupId')}")
      else
        $location.path(ipCookie('initialRequestPath'))

    $scope.$on 'auth:validation-success', (event, user) ->
      $scope.redirectToGroupPage(user)

    $scope.$on 'auth:login-success', (event, user) ->
      $scope.redirectToGroupPage(user)

    $scope.$on 'auth:login-error', () ->
      $scope.formError = "Invalid Credentials"

    return