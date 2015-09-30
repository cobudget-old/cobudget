module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, AuthenticateUser, ipCookie) ->

    $scope.validatingUser = true
    $auth.validateUser()
      .then ->
        $scope.redirectToGroupPage()
      .catch ->
        $scope.validatingUser = false

    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin(formData) 
        .then ->
          $scope.redirectToGroupPage()
        .catch ->
          $scope.formError = "Invalid Credentials"

    $scope.redirectToGroupPage = () ->
      Records.memberships.fetchMyMemberships().then (data) ->
        ipCookie('currentGroupId', data.groups[0].id)
        $location.path("/groups/#{ipCookie('currentGroupId')}")

    return