module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, $location, Records, Error) ->

    Error.clear()

    $auth.validateUser()
      .then ->
        Records.memberships.fetchMyMemberships().then (data) ->
          groupId = data.groups[0].id
          $location.path("/groups/#{groupId}")

    global.cobudgetApp.membershipsLoaded.then (data) ->
      groupId = data.groups[0].id
      $location.path("/groups/#{groupId}")

    $scope.login = (formData) ->
      $scope.formError = ""
      $auth.submitLogin(formData) 
        .catch ->
          $scope.formError = "Invalid Credentials"

    return