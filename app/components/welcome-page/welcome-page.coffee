module.exports = 
  url: '/'
  template: require('./welcome-page.html')
  controller: ($auth, Dialog, Error, LoadBar, $location, Records, $scope) ->

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
      $auth.submitLogin(formData)
        .catch ->
          Dialog.alert(title: 'error!', content: 'invalid credentials')
          LoadBar.stop()

    $scope.visitForgotPasswordPage = ->
      $location.path('/forgot_password')

    return