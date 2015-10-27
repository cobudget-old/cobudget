module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($scope, $auth, LoadBar, $location, Records, Error) ->

    Error.clear()
    LoadBar.start()

    $auth.validateUser()
      .then ->
        Records.memberships.fetchMyMemberships().then (data) ->
          groupId = data.groups[0].id
          $location.path("/groups/#{groupId}")
      .catch ->
        LoadBar.stop()
          
    $scope.login = (formData) ->
      LoadBar.start()
      $scope.formError = ""
      $auth.submitLogin(formData) 
        .catch ->
          $scope.formError = "Invalid Credentials"
          LoadBar.stop()

    return