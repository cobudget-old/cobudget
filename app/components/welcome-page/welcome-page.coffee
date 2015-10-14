module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, Error, CurrentUser) ->

    Error.clear()
    
    $scope.$on 'auth:validation-success', (ev, user) ->
      $scope.redirectToGroupPage()

    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin(formData) 
        .then (data) ->
          $scope.redirectToGroupPage()
        .catch ->
          $scope.formError = "Invalid Credentials"

    $scope.redirectToGroupPage = () ->
      Records.memberships.fetchMyMemberships().then (data) ->
        groupId = data.groups[0].id
        $location.path("/groups/#{groupId}")

    return